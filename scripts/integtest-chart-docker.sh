#!/bin/bash

if [ -z "$1" ]; then
    echo "Use first argument to select app, for example: 'deploy', or 'release'."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Use second argument to select tests, for example: 'basic', or 'external'."
    exit 1
fi

if [ -z "$3" ]; then
    echo "Use third argument to select tests 'plain', or 'openshift'"
    exit 1
fi


APP_TYPE="$1"
APP_TESTS="$2"
APP_TARGET="$3"

APP_SHORT_TYPE=xlr
if [ "$APP_TYPE" = "deploy" ]; then
    APP_SHORT_TYPE=xld
fi

APP_OPERATOR="operator-${APP_TYPE}-${APP_TESTS}"
OUTPUT_HOST_DIR=./build/integtest/$APP_TARGET
OUTPUT_CONTAINER_DIR="/opt/project"
TEST_DIR="${OUTPUT_CONTAINER_DIR}/tests/e2e/${APP_OPERATOR}.yaml"
VERSION_FILE=./xl-op/override-defaults.yaml
XL_CLIENT_VERSION_DEFAULT=25.1.0-master
XL_CLIENT_VERSION=${XL_CLIENT_VERSION:-$XL_CLIENT_VERSION_DEFAULT}
XL_APP_VERSION_DEFAULT=$(yq eval ".ImageTag" "$VERSION_FILE")
XL_APP_VERSION=${XL_APP_VERSION:-$XL_APP_VERSION_DEFAULT}
XL_RR_VERSION_DEFAULT=$(yq eval ".ImageTagRemoteRunner" "$VERSION_FILE")
XL_RR_VERSION=${XL_RR_VERSION:-$XL_RR_VERSION_DEFAULT}
EXTRA_CONTAINER_ARGS=""

echo "Prepare tests for: ${APP_OPERATOR} ON ${APP_TARGET}"

rm -fr $OUTPUT_HOST_DIR/tests
mkdir -p $OUTPUT_HOST_DIR
cp -R ./tests $OUTPUT_HOST_DIR
mkdir -p $OUTPUT_HOST_DIR/tools
mkdir -p $OUTPUT_HOST_DIR/logs
mkdir -p $OUTPUT_HOST_DIR/kube
chmod -R 777 $OUTPUT_HOST_DIR

echo "Download latest xl-cli ${XL_CLIENT_VERSION}"

curl -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
    -o $OUTPUT_HOST_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin \
    https://nexus.xebialabs.com/nexus/content/repositories/releases/com/xebialabs/xlclient/xl-client/${XL_CLIENT_VERSION}/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin
chmod 755 $OUTPUT_HOST_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin

echo "Setup versions:"
echo "  XL_CLIENT_VERSION=$XL_CLIENT_VERSION"
echo "  XL_APP_VERSION=$XL_APP_VERSION"
echo "  XL_RR_VERSION=$XL_RR_VERSION"

yq eval ".ImageTag = \"$XL_APP_VERSION\"" $OUTPUT_HOST_DIR/tests/answers/${APP_TARGET}/*.yaml -i
yq eval ".ImageTagRemoteRunner = \"$XL_RR_VERSION\"" $OUTPUT_HOST_DIR/tests/answers/${APP_TARGET}/*.yaml -i

if [[ "$APP_TARGET" = "openshift" && "$4" == "withLogin" ]]; then
    if [ -z "$REDHAT_OC_URL" || -z "$REDHAT_OC_LOGIN" || -z "$REDHAT_OC_PASSWORD" || $REDHAT_REGISTRY_SA || $REDHAT_REGISTRY_SA_TOKEN ]; then
        echo "Openshift environment variables are not set. Please set REDHAT_OC_URL, REDHAT_OC_LOGIN, REDHAT_OC_PASSWORD, REDHAT_REGISTRY_SA and REDHAT_REGISTRY_SA_TOKEN."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    # uses https://catalog.redhat.com/software/containers/openshift4/ose-cli/5cd9ba3f5a13467289f4d51d?container-tabs=overview
    docker login -u="$REDHAT_REGISTRY_SA" -p="$REDHAT_REGISTRY_SA_TOKEN" registry.redhat.io
    docker run --rm \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        registry.redhat.io/openshift4/ose-cli:latest \
        oc login $REDHAT_OC_URL --username $REDHAT_OC_LOGIN --password $REDHAT_OC_PASSWORD

elif [[ "$APP_TARGET" = "aws" && "$4" == "withLogin" ]]; then
    echo "Setting up for AWS"

    if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_DEFAULT_REGION" || -z "$EKS_CLUSTER_NAME" ]]; then
        echo "AWS environment variables are not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION and EKS_CLUSTER_NAME."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    docker run --rm \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        amazon/aws-cli:latest \
        aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_DEFAULT_REGION

elif [[ "$APP_TARGET" = "azure" && "$4" == "withLogin" ]]; then
    echo "Setting up for Azure"

    if [[ -z "$AZURE_SUBSCRIPTION_ID" || -z "$AZURE_CLIENT_ID" || -z "$AZURE_CLIENT_SECRET" || -z "$AZURE_TENANT_ID" || -z "$AKS_CLUSTER_NAME" || -z "$AZURE_RESOURCE_GROUP" ]]; then
        echo "Azure environment variables are not set. Please set AZURE_SUBSCRIPTION_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID, AKS_CLUSTER_NAME, and AZURE_RESOURCE_GROUP."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    docker run --rm \
        -e AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID \
        -e AZURE_CLIENT_ID=$AZURE_CLIENT_ID \
        -e AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET \
        -e AZURE_TENANT_ID=$AZURE_TENANT_ID \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        mcr.microsoft.com/azure-cli:latest \
        # bash -c "az login -u $AZURE_USERNAME -p $AZURE_PASSWORD && az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --overwrite-existing" \
        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID && az aks get-credentials --name $AKS_CLUSTER_NAME --resource-group $AZURE_RESOURCE_GROUP

elif [[ "$APP_TARGET" = "gcp" && "$4" == "withLogin" ]]; then
    echo "Setting up for GCP"

    if [[ -z "$GCP_PROJECT" || -z "$GCP_CLUSTER_NAME" || -z "$GCP_ZONE" || -z "$GCP_SERVICE_ACCOUNT_KEY" ]]; then
        echo "GCP environment variables are not set. Please set GCP_PROJECT, GCP_CLUSTER_NAME, GCP_ZONE, and GCP_SERVICE_ACCOUNT_KEY."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    docker run --rm \
        -e CLOUDSDK_CORE_PROJECT=$GCP_PROJECT \
        -v $GCP_SERVICE_ACCOUNT_KEY:/tmp/keyfile.json \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        google/cloud-sdk:latest \
        gcloud auth activate-service-account --key-file=/tmp/keyfile.json && gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone $GCP_ZONE --project $GCP_PROJECT

elif [[ "$APP_TARGET" = "gcp" && "$4" == "withLogin" ]]; then
    echo "Setting up for GCP"

    if [[ -z "$GCP_PROJECT" || -z "$GCP_CLUSTER_NAME" || -z "$GCP_ZONE" || -z "$GCP_ACCOUNT_CRED_FILE" || -z "$GCP_SERVICE_ACCOUNT_EMAIL" ]]; then
        echo "GCP environment variables are not set. Please set GCP_PROJECT, GCP_CLUSTER_NAME, GCP_ZONE, GCP_SERVICE_ACCOUNT_KEY, and GCP_SERVICE_ACCOUNT_EMAIL."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

elif [[ "$APP_TARGET" = "plain" && "$4" == "localhost" ]]; then

    echo "Using exising kube context"

    cp -f $HOME/.kube/config $OUTPUT_HOST_DIR/kube/    
    EXTRA_CONTAINER_ARGS="--network=host"
fi

if [ "$APP_TARGET" = "openshift" ]; then

    echo "Change CR name to dai-ocp-$APP_SHORT_TYPE"

    grep -rl "dai-$APP_SHORT_TYPE" $OUTPUT_HOST_DIR/tests/e2e/apply | xargs sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
    grep -rl "dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-" $OUTPUT_HOST_DIR/tests/e2e/asserts | xargs sed -i "s/dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-/dai-ocp-$APP_SHORT_TYPE-digitalai-$APP_TYPE-ocp-/g"
    grep -rl "dai-$APP_SHORT_TYPE" $OUTPUT_HOST_DIR/tests/e2e/asserts | xargs sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
    grep -rl "dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-" $OUTPUT_HOST_DIR/tests/e2e/*/$APP_TYPE/steps | xargs sed -i "s/dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-/dai-ocp-$APP_SHORT_TYPE-digitalai-$APP_TYPE-ocp-/g"
    grep -rl "dai-$APP_SHORT_TYPE" $OUTPUT_HOST_DIR/tests/e2e/*/$APP_TYPE/steps | xargs sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
fi

echo "Starting tests for: ${APP_OPERATOR} ON ${APP_TARGET}"

# tools: xl-client keytool yq helm 
docker run --rm $EXTRA_CONTAINER_ARGS \
    -e HOME=$OUTPUT_CONTAINER_DIR \
    -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
    -e ANSWERS_REL_PATH=../../../../answers/$APP_TARGET \
    -e APPLY_REL_PATH=../../../apply \
    -e ASSERTS_REL_PATH=../../../asserts \
    -e SCRIPTS_REL_PATH=../../../scripts \
    -e BUILD_REL_PATH=../../../../../build/e2e \
    -e XL_SKIP_TOOL_CHECK=true \
    -e XL_CLI=$OUTPUT_CONTAINER_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin \
    -e XL_CLI_CLEAN_EXTRA="--clean-force --clean-grace-period 1" \
    -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
    -u $(id -u):$(id -g) \
    xldevdocker/kuttl:latest \
    --artifacts-dir $OUTPUT_CONTAINER_DIR/logs --config $TEST_DIR

echo "TEST RESULT:"
cat "$OUTPUT_HOST_DIR/logs/${APP_OPERATOR}.json"
echo ""

# check for failure in file
if grep -q '"failure"' "$OUTPUT_HOST_DIR/logs/${APP_OPERATOR}.json"; then
  echo "Tests failed"
  exit 1
else 
  echo "Tests success"
fi
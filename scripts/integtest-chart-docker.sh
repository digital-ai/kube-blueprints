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
    echo "Use third argument to select provider, for example: 'plain', 'aws', 'gcp' or 'openshift'"
    exit 1
fi

APP_TYPE="$1"
APP_TESTS="$2"
APP_TARGET="$3"
XL_APP_VERSION_DEFAULT=""

APP_SHORT_TYPE=xlr
if [ "$APP_TYPE" = "deploy" ]; then
    APP_SHORT_TYPE=xld
fi

APP_OPERATOR="operator-${APP_TYPE}-${APP_TESTS}"
OUTPUT_HOST_DIR=$(pwd)/build/integtest
OUTPUT_CONTAINER_DIR="/opt/project"
TEST_DIR="${OUTPUT_CONTAINER_DIR}/tests/e2e/${APP_OPERATOR}.yaml"
VERSION_FILE=./xl-op/override-defaults.yaml
XL_CLIENT_VERSION_DEFAULT=25.3.0-master
XL_CLIENT_VERSION=${XL_CLIENT_VERSION:-$XL_CLIENT_VERSION_DEFAULT}
if [ "$APP_TYPE" = "deploy" ]; then
    XL_APP_VERSION_DEFAULT=$(yq eval ".ImageTagDeploy" "$VERSION_FILE")
fi
if [ "$APP_TYPE" = "release" ]; then
    XL_APP_VERSION_DEFAULT=$(yq eval ".ImageTagRelease" "$VERSION_FILE")
fi
XL_APP_VERSION=${XL_APP_VERSION:-$XL_APP_VERSION_DEFAULT}
XL_RR_VERSION_DEFAULT=$(yq eval ".ImageTagReleaseRunner" "$VERSION_FILE")
XL_RR_VERSION=${XL_RR_VERSION:-$XL_RR_VERSION_DEFAULT}
EXTRA_CONTAINER_ARGS=""

# Validate required environment variables
if [[ -z "$APP_TARGET" || -z "$APP_SHORT_TYPE" || -z "$APP_TYPE" || -z "$APP_OPERATOR" ]]; then
    echo "Error: Required environment variables not set"
    echo "Required: APP_TARGET, APP_SHORT_TYPE, APP_TYPE, APP_OPERATOR"
    exit 1
fi

echo "Prepare tests for: ${APP_OPERATOR} ON ${APP_TARGET}"

rm -fr $OUTPUT_HOST_DIR/tests
mkdir -p $OUTPUT_HOST_DIR
cp -R ./tests $OUTPUT_HOST_DIR
mkdir -p "$OUTPUT_HOST_DIR"/{tools,logs,kube}
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

if [ "$APP_TYPE" = "deploy" ]; then
    yq eval ".ImageTagDeploy = \"$XL_APP_VERSION\"" $OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}/*.yaml -i
fi
if [ "$APP_TYPE" = "release" ]; then
    yq eval ".ImageTagRelease = \"$XL_APP_VERSION\"" $OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}/*.yaml -i
fi
yq eval ".ImageTagReleaseRunner = \"$XL_RR_VERSION\"" $OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}/*.yaml -i

if [[ "$APP_TARGET" = "openshift" && "$4" == "withLogin" ]]; then
    if [[ -z "$REDHAT_OC_URL" || -z "$REDHAT_OC_LOGIN" || -z "$REDHAT_OC_PASSWORD" || -z "$REDHAT_REGISTRY_SA" || -z "$REDHAT_REGISTRY_SA_TOKEN" ]]; then
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

    if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_REGION" || -z "$AWS_CLUSTER_NAME" || -z "$AWS_SESSION_TOKEN" ]]; then
        echo "AWS environment variables are not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION and AWS_CLUSTER_NAME."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    docker run --rm \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        -e AWS_REGION=$AWS_REGION \
        -e AWS_CLUSTER_NAME=$AWS_CLUSTER_NAME \
        -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
        -e K8S_AUTH_TOKEN=$TOKEN \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        amazon/aws-cli:latest \
        eks --region $AWS_REGION update-kubeconfig --name $AWS_CLUSTER_NAME
    TOKEN=$(aws eks get-token --region $AWS_REGION --cluster-name $AWS_CLUSTER_NAME --output json | jq -r '.status.token')
    kubectl --kubeconfig=$OUTPUT_HOST_DIR/kube/config config set-credentials kuttl-user --token=$TOKEN
    kubectl --kubeconfig=$OUTPUT_HOST_DIR/kube/config config set-context --current --user=kuttl-user

elif [[ "$APP_TARGET" = "azure" && "$4" == "withLogin" ]]; then
   echo "Setting up for Azure"

   if [[ -z "$AZURE_USER" || -z "$AZURE_PASSWORD" || -z "$AZURE_CLUSTER_NAME" || -z "$AZURE_RESOURCE_GROUP" ]]; then
       echo "Azure environment variables are not set. Please set AZURE_USER, AZURE_PASSWORD, AZURE_CLUSTER_NAME, and AZURE_RESOURCE_GROUP."
       exit 1
   fi
   echo "Auth to $APP_TARGET"

   docker run --rm \
       -e AZURE_USER=$AZURE_USER \
       -e AZURE_PASSWORD=$AZURE_PASSWORD \
       -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
       -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
       mcr.microsoft.com/azure-cli:latest \
       az login -u $AZURE_USER -p $AZURE_PASSWORD && az aks get-credentials --name $AZURE_CLUSTER_NAME --resource-group $AZURE_RESOURCE_GROUP --overwrite-existing

elif [[ "$APP_TARGET" = "gcp" && "$4" == "withLogin" ]]; then
    echo "Setting up for GCP"

    if [[ -z "$GCP_PROJECT" || -z "$GCP_CLUSTER_NAME" || -z "$GCP_ZONE" || -z "$GCP_KEYFILE_JSON" ]]; then
        echo "GCP environment variables are not set. Please set GCP_PROJECT, GCP_CLUSTER_NAME, GCP_ZONE, and GCP_KEYFILE_JSON."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    docker run --rm \
        -e HOME=$OUTPUT_CONTAINER_DIR \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -e CLOUDSDK_CORE_PROJECT=$GCP_PROJECT \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        google/cloud-sdk:latest \
        sh -c "gcloud auth activate-service-account --key-file=$GCP_KEYFILE_JSON && \
           gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone $GCP_ZONE --project $GCP_PROJECT && \
           TOKEN=\$(gcloud auth print-access-token) && \
           kubectl config set-credentials kuttl-user --token=\$TOKEN && \
           kubectl config set-context --current --user=kuttl-user"

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
    -e ANSWERS_REL_PATH=../../../../answers/generated/$APP_TARGET \
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

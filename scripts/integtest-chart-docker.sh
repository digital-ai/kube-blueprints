#!/bin/bash
# This script runs integration tests inside a Docker container for different providers or local kube context for plain K8s.
# Usage: ./scripts/integtest-chart-docker-local.sh <app_type> <app_tests> <app_target> <login_mode>
# Where:
#   <app_type>    : 'deploy' or 'release'
#   <app_tests>   : 'basic' or 'external'
#   <app_target>  : 'plain', 'aws', 'gcp', 'openshift'
#   <login_mode>  : 'withLogin' for cloud providers, 'localhost' for plain local kube context.
# Note: 1. Ensure you have Docker installed and running, and that you have access to the required Nexus repository for downloading xl-cli.
#       2. Set necessary environment variables for cloud provider authentication when using 'withLogin' mode.
#       3. Invoke the script from the kube-blueprints root directory.
# Example: cd kube-blueprints && ./scripts/integtest-chart-docker-local.sh release basic gcp withLogin
#       cd kube-blueprints && ./scripts/integtest-chart-docker-local.sh release basic plain localhost
#       cd kube-blueprints && ./scripts/integtest-chart-docker-local.sh deploy external openshift withLogin

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

if [ -z "$4" ]; then
    echo "Use fourth argument to specify login mode, for example: 'withLogin' for provider, 'localhost' for plain local kube context."
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
# Use WORKSPACE env var if available (Jenkins), otherwise use current directory
WORKSPACE_ROOT="${WORKSPACE:-$(pwd)}"
OUTPUT_HOST_DIR="$WORKSPACE_ROOT/build/integtest"
OUTPUT_CONTAINER_DIR="/opt/project"
TEST_DIR="${OUTPUT_CONTAINER_DIR}/tests/e2e/${APP_OPERATOR}.yaml"
VERSION_FILE=./xl-op/override-defaults.yaml

XL_APP_VERSION_DEFAULT=""
XL_APP_OPERATOR_VERSION_DEFAULT=""
if [ "$APP_TYPE" = "deploy" ]; then
    XL_APP_VERSION_DEFAULT=$(yq eval ".ImageTagDeploy" "$VERSION_FILE")
    XL_APP_OPERATOR_VERSION_DEFAULT=$(yq eval ".OperatorImageTagDeploy" "$VERSION_FILE")
fi
if [ "$APP_TYPE" = "release" ]; then
    XL_APP_VERSION_DEFAULT=$(yq eval ".ImageTagRelease" "$VERSION_FILE")
    XL_APP_OPERATOR_VERSION_DEFAULT=$(yq eval ".OperatorImageTagRelease" "$VERSION_FILE")
fi
XL_APP_VERSION=${XL_APP_VERSION:-$XL_APP_VERSION_DEFAULT}
XL_APP_OPERATOR_VERSION=${XL_APP_OPERATOR_VERSION:-$XL_APP_OPERATOR_VERSION_DEFAULT}

XL_RR_VERSION_DEFAULT=$(yq eval ".ImageTagReleaseRunner" "$VERSION_FILE")
XL_RR_VERSION=${XL_RR_VERSION:-$XL_RR_VERSION_DEFAULT}

XL_CLIENT_VERSION_DEFAULT=${XL_APP_OPERATOR_VERSION}
XL_CLIENT_VERSION=${XL_CLIENT_VERSION:-$XL_CLIENT_VERSION_DEFAULT}

EXTRA_CONTAINER_ARGS=""

# Validate required environment variables
if [[ -z "$APP_TARGET" || -z "$APP_SHORT_TYPE" || -z "$APP_TYPE" || -z "$APP_OPERATOR" ]]; then
    echo "Error: Required environment variables not set"
    echo "Required: APP_TARGET, APP_SHORT_TYPE, APP_TYPE, APP_OPERATOR"
    exit 1
fi

echo "Prepare tests for: ${APP_OPERATOR} ON ${APP_TARGET}"

rm -fr "$OUTPUT_HOST_DIR/tests"
mkdir -p "$OUTPUT_HOST_DIR"
cp -R ./tests "$OUTPUT_HOST_DIR"
mkdir -p "$OUTPUT_HOST_DIR"/{tools,logs,kube}
chmod -R 777 "$OUTPUT_HOST_DIR"

echo "Download latest xl-cli ${XL_CLIENT_VERSION}"

curl -f --progress-bar -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
    -o "$OUTPUT_HOST_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin" \
    "https://nexus.xebialabs.com/nexus/content/repositories/releases/com/xebialabs/xlclient/xl-client/${XL_CLIENT_VERSION}/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin"
chmod 755 "$OUTPUT_HOST_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin"

echo "Setup versions:"
echo "  XL_CLIENT_VERSION=$XL_CLIENT_VERSION"
echo "  XL_APP_OPERATOR_VERSION=$XL_APP_OPERATOR_VERSION"
echo "  XL_APP_VERSION=$XL_APP_VERSION"
echo "  XL_RR_VERSION=$XL_RR_VERSION"

if [ "$APP_TYPE" = "deploy" ]; then
    for file in "$OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}"/*.yaml; do
        yq eval ".ImageTagDeploy = \"$XL_APP_VERSION\"" "$file" -i
        yq eval ".OperatorImageTagDeploy = \"$XL_APP_OPERATOR_VERSION\"" "$file" -i
    done
fi
if [ "$APP_TYPE" = "release" ]; then
    for file in "$OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}"/*.yaml; do
        yq eval ".ImageTagRelease = \"$XL_APP_VERSION\"" "$file" -i
        yq eval ".OperatorImageTagRelease = \"$XL_APP_OPERATOR_VERSION\"" "$file" -i
    done
fi
for file in "$OUTPUT_HOST_DIR/tests/answers/generated/${APP_TARGET}"/*.yaml; do
    yq eval ".ImageTagReleaseRunner = \"$XL_RR_VERSION\"" "$file" -i
done

if [[ "$APP_TARGET" = "openshift" && "$4" == "withLogin" ]]; then
    if [[ -z "$REDHAT_OC_URL" || -z "$REDHAT_OC_LOGIN" || -z "$REDHAT_OC_PASSWORD" || -z "$REDHAT_REGISTRY_SA" || -z "$REDHAT_REGISTRY_SA_TOKEN" ]]; then
        echo "Openshift environment variables are not set. Please set REDHAT_OC_URL, REDHAT_OC_LOGIN, REDHAT_OC_PASSWORD, REDHAT_REGISTRY_SA and REDHAT_REGISTRY_SA_TOKEN."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    # uses https://catalog.redhat.com/software/containers/openshift4/ose-cli/5cd9ba3f5a13467289f4d51d?container-tabs=overview
    docker login -u="$REDHAT_REGISTRY_SA" -p="$REDHAT_REGISTRY_SA_TOKEN" registry.redhat.io || {
        echo "ERROR: Failed to login to Red Hat registry. Check REDHAT_REGISTRY_SA and REDHAT_REGISTRY_SA_TOKEN."
        exit 1
    }
    
    echo "SUCCESS: Red Hat registry login completed, authenticating with OpenShift cluster..."
    
    docker run --rm \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
        -u $(id -u):$(id -g) \
        registry.redhat.io/openshift4/ose-cli:latest \
        oc login $REDHAT_OC_URL --username $REDHAT_OC_LOGIN --password $REDHAT_OC_PASSWORD || {
        echo "ERROR: Failed to login to OpenShift cluster. Check REDHAT_OC_URL, REDHAT_OC_LOGIN and REDHAT_OC_PASSWORD."
        exit 1
    }
    
    echo "SUCCESS: OpenShift authentication completed."

elif [[ "$APP_TARGET" = "aws" && "$4" == "withLogin" ]]; then
    echo "Setting up for AWS"

    if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_REGION" || -z "$AWS_CLUSTER_NAME" ]]; then
        echo "AWS environment variables are not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION and AWS_CLUSTER_NAME."
        echo "AWS_SESSION_TOKEN is optional and only required for temporary credentials when AWS CLI profile uses AWS SSO, MFA or assume-role scenarios."
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    TOKEN=$(docker run --rm \
        --entrypoint sh \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        -e AWS_REGION=$AWS_REGION \
        -e AWS_CLUSTER_NAME=$AWS_CLUSTER_NAME \
        -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
        -u $(id -u):$(id -g) \
        amazon/aws-cli:latest \
        -c "aws eks --region $AWS_REGION update-kubeconfig --name $AWS_CLUSTER_NAME > /dev/null && \
            aws eks get-token --cluster-name $AWS_CLUSTER_NAME --region $AWS_REGION --output text --query 'status.token'") || {
        echo "ERROR: Failed to configure kubeconfig for EKS cluster. Check your AWS credentials, region and cluster name."
        echo "Note: For temporary credentials (STS, assume-role, MFA, or AWS SSO), ensure AWS_SESSION_TOKEN is set and valid."
        exit 1
    }

    if [[ -z "$TOKEN" ]]; then
        echo "ERROR: Failed to get authentication token from AWS EKS."
        exit 1
    fi

    docker run --rm \
        --entrypoint sh \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
        -u $(id -u):$(id -g) \
        bitnami/kubectl:latest \
        -c "kubectl config set-credentials kuttl-user --token='$TOKEN' && \
            kubectl config set-context --current --user=kuttl-user" || {
        echo "ERROR: Failed to configure kubectl credentials with static token."
        exit 1
    }

    echo "SUCCESS: AWS EKS kubeconfig configured with static token."

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
       -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
       mcr.microsoft.com/azure-cli:latest \
       az login -u $AZURE_USER -p $AZURE_PASSWORD && az aks get-credentials --name $AZURE_CLUSTER_NAME --resource-group $AZURE_RESOURCE_GROUP --overwrite-existing || {
       echo "ERROR: Failed to authenticate with Azure or get AKS credentials. Check AZURE_USER, AZURE_PASSWORD, AZURE_CLUSTER_NAME and AZURE_RESOURCE_GROUP."
       exit 1
   }
   
   echo "SUCCESS: Azure AKS authentication completed."

elif [[ "$APP_TARGET" = "gcp" && "$4" == "withLogin" ]]; then
    echo "Setting up for GCP"

    if [[ -z "$GCP_PROJECT" || -z "$GCP_CLUSTER_NAME" || -z "$GCP_ZONE" ]]; then
        echo "GCP environment variables are not set. Please set GCP_PROJECT, GCP_CLUSTER_NAME, and GCP_ZONE."
        exit 1
    elif [[ ! -f "$GCP_KEYFILE_JSON" ]]; then
        echo "ERROR: GCP service account key file not found or GCP_KEYFILE_JSON not set: $GCP_KEYFILE_JSON"
        echo "Note: Ensure this env variable is set with file path of the service account key JSON file."
        exit 1
    elif ! cp "$GCP_KEYFILE_JSON" "$OUTPUT_HOST_DIR/gcp-keyfile.json"; then
        echo "ERROR: Failed to copy GCP key file from $GCP_KEYFILE_JSON to $OUTPUT_HOST_DIR/gcp-keyfile.json"
        exit 1
    fi
    echo "Auth to $APP_TARGET"

    TOKEN=$(docker run --rm \
        --entrypoint sh \
        -e HOME=$OUTPUT_CONTAINER_DIR \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -e CLOUDSDK_CORE_PROJECT=$GCP_PROJECT \
        -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
        -u $(id -u):$(id -g) \
        google/cloud-sdk:latest \
        -c "gcloud auth activate-service-account --key-file=$OUTPUT_CONTAINER_DIR/gcp-keyfile.json && \
            gcloud container clusters get-credentials $GCP_CLUSTER_NAME --zone $GCP_ZONE --project $GCP_PROJECT && \
            gcloud auth print-access-token") || {
        echo "ERROR: Failed to authenticate with GCP or get cluster credentials. Check your service account key file, project, cluster name, and zone."
        echo "Note: Ensure the service account has necessary permissions."
        exit 1
    }
    
    # Clean up the copied key file for security
    rm -f "$OUTPUT_HOST_DIR/gcp-keyfile.json"
    
    if [[ -z "$TOKEN" ]]; then
        echo "ERROR: Failed to get authentication token from GCP."
        exit 1
    fi
    
    echo "SUCCESS: GCP authentication completed, configuring kubectl credentials..."
    
    docker run --rm \
        --entrypoint sh \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
        -u $(id -u):$(id -g) \
        bitnami/kubectl:latest \
        -c "kubectl config set-credentials kuttl-user --token='$TOKEN' && \
               kubectl config set-context --current --user=kuttl-user" || {
        echo "ERROR: Failed to configure kubectl credentials."
        exit 1
    }
    
    echo "SUCCESS: GCP authentication and kubectl configuration completed."

elif [[ "$APP_TARGET" = "plain" && "$4" == "localhost" ]]; then

    echo "Using existing kube context"

    cp -f $HOME/.kube/config "$OUTPUT_HOST_DIR/kube/" || {
        echo "ERROR: Failed to copy kubeconfig from $HOME/.kube/config. Ensure kubectl is configured locally."
        exit 1
    }
    
    echo "SUCCESS: Local kubeconfig copied successfully."
    EXTRA_CONTAINER_ARGS="--network=host"
fi

if [ "$APP_TARGET" = "openshift" ]; then

    echo "Change CR name to dai-ocp-$APP_SHORT_TYPE"

    grep -rlZ "dai-$APP_SHORT_TYPE" "$OUTPUT_HOST_DIR"/tests/e2e/apply | xargs -0 sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
    grep -rlZ "dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-" "$OUTPUT_HOST_DIR"/tests/e2e/asserts | xargs -0 sed -i "s/dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-/dai-ocp-$APP_SHORT_TYPE-digitalai-$APP_TYPE-ocp-/g"
    grep -rlZ "dai-$APP_SHORT_TYPE" "$OUTPUT_HOST_DIR"/tests/e2e/asserts | xargs -0 sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
    grep -rlZ "dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-" "$OUTPUT_HOST_DIR"/tests/e2e/*/$APP_TYPE/steps | xargs -0 sed -i "s/dai-$APP_SHORT_TYPE-digitalai-$APP_TYPE-/dai-ocp-$APP_SHORT_TYPE-digitalai-$APP_TYPE-ocp-/g"
    grep -rlZ "dai-$APP_SHORT_TYPE" "$OUTPUT_HOST_DIR"/tests/e2e/*/$APP_TYPE/steps | xargs -0 sed -i "s/dai-$APP_SHORT_TYPE/dai-ocp-$APP_SHORT_TYPE/g"
fi

echo "Starting tests for: ${APP_OPERATOR} ON ${APP_TARGET}"



# tools: xl-client keytool yq helm
docker run --rm $EXTRA_CONTAINER_ARGS \
    -e HOME=$OUTPUT_CONTAINER_DIR \
    -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
    -e ANSWERS_REL_PATH="$OUTPUT_CONTAINER_DIR/tests/answers/generated/$APP_TARGET" \
    -e APPLY_REL_PATH="$OUTPUT_CONTAINER_DIR/tests/e2e/apply" \
    -e ASSERTS_REL_PATH="$OUTPUT_CONTAINER_DIR/tests/e2e/asserts" \
    -e SCRIPTS_REL_PATH="$OUTPUT_CONTAINER_DIR/tests/e2e/scripts" \
    -e BUILD_REL_PATH="$OUTPUT_CONTAINER_DIR/build/e2e" \
    -e XL_SKIP_TOOL_CHECK=true \
    -e XL_CLI=$OUTPUT_CONTAINER_DIR/tools/xl-client-${XL_CLIENT_VERSION}-linux-amd64.bin \
    -e XL_CLI_CLEAN_EXTRA="--clean-force --clean-grace-period 1" \
    -v "$OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw" \
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

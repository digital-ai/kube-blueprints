#!/bin/bash

if [ -z "$1" ]; then
    echo "Use first argument to select app, for example: 'deploy', or 'release'."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Use first argument to select tests, for example: 'basic', or 'external'."
    exit 1
fi

if [ -z "$3" ]; then
    echo "Use second argument to select tests 'plain', or 'openshift'"
    exit 1
fi

if [[ "$3" = "openshift" && "$4" == "withLogin" ]]; then
    if [ -z "$REDHAT_OC_URL" ]; then
        echo "The '\$REDHAT_OC_URL environment variable is not set."
        exit 1
    fi

    if [ -z "$REDHAT_OC_LOGIN" ]; then
        echo "The '\$REDHAT_OC_LOGIN environment variable is not set."
        exit 1
    fi

    if [ -z "$REDHAT_OC_PASSWORD" ]; then
        echo "The '\$REDHAT_OC_PASSWORD environment variable is not set."
        exit 1
    fi
fi


APP_TYPE="$1"
APP_TESTS="$2"
APP_TARGET="$3"

APP_SHORT_TYPE=xlr
if [ "$APP_TYPE" = "deploy" ]; then
    APP_SHORT_TYPE=xld
fi

APP_OPERATOR="operator-${APP_TYPE}-${APP_TESTS}"
OUTPUT_HOST_DIR=./build/integtest
OUTPUT_CONTAINER_DIR="/opt/project"
TEST_DIR="${OUTPUT_CONTAINER_DIR}/tests/e2e/${APP_OPERATOR}.yaml"
VERSION_FILE=./xl-op/override-defaults.yaml
XL_CLIENT_VERSION_DEFAULT=24.3.0-24.3.x-maintenance
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

echo "Download leatest xl-cli ${XL_CLIENT_VERSION}"

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

    echo "Auth to $APP_TARGET"

    # uses https://catalog.redhat.com/software/containers/openshift4/ose-cli/5cd9ba3f5a13467289f4d51d?container-tabs=overview
    docker login -u="$REDHAT_REGISTRY_SA" -p="$REDHAT_REGISTRY_SA_TOKEN" registry.redhat.io
    docker run --rm \
        -e KUBECONFIG=$OUTPUT_CONTAINER_DIR/kube/config \
        -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
        -u $(id -u):$(id -g) \
        registry.redhat.io/openshift4/ose-cli:latest \
        oc login $REDHAT_OC_URL --username $REDHAT_OC_LOGIN --password $REDHAT_OC_PASSWORD

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
    -e XL_CLI_CLEAN_EXTRA="" \
    -v $OUTPUT_HOST_DIR:$OUTPUT_CONTAINER_DIR:rw \
    -u $(id -u):$(id -g) \
    xldevdocker/kuttl:latest \
    --artifacts-dir $OUTPUT_CONTAINER_DIR/logs --config $TEST_DIR

echo "TEST RESULT:"
cat "$OUTPUT_HOST_DIR/logs/${APP_OPERATOR}.json"
echo ""

# check for fauilure in file
if grep -q '"failure"' "$OUTPUT_HOST_DIR/logs/${APP_OPERATOR}.json"; then
  echo "Tests failed"
  exit 1
else 
  echo "Tests success"
fi
SCRIPT_DIR=$( dirname -- "$0"; )
OUTPUT_DIR="${SCRIPT_DIR}/build/e2e"
TEST_DIR="${SCRIPT_DIR}/tests/e2e/operator.yaml"
export ANSWERS_REL_PATH=../../../../answers
export APPLY_REL_PATH=../../../apply
export ASSERTS_REL_PATH=../../../asserts
export SCRIPTS_REL_PATH=../../../scripts
export BUILD_REL_PATH=../../../../../build/e2e
export XL_CLI=xl-24.1.6
# require https://kuttl.dev/docs/cli.html#setup-the-kuttl-kubectl-plugin - `kubectl krew install kuttl`
kubectl kuttl test --artifacts-dir $OUTPUT_DIR --config $TEST_DIR

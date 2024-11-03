#!/bin/bash

# Read the YAML file and export the variables
while IFS=: read -r key value; do
  key=$(echo $key | xargs)  # Trim whitespace
  value=$(echo $value | xargs)  # Trim whitespace
  export $key=$value
done < ./xl-op/override-defaults.yaml

cat <<EOF
docker.io/${RepositoryName}/release-operator:${OperatorImageTag}
docker.io/${RepositoryName}/deploy-operator:${OperatorImageTag}
docker.io/${RepositoryName}/xl-release:${ImageTag}-ubuntu
docker.io/${RepositoryName}/xl-release:${ImageTag}-ubuntu-slim
docker.io/${RepositoryName}/xl-release:${ImageTag}-redhat
docker.io/${RepositoryName}/xl-release:${ImageTag}-redhat-slim
docker.io/${RepositoryName}/central-configuration:${ImageTag}-ubuntu
docker.io/${RepositoryName}/central-configuration:${ImageTag}-ubuntu-slim
docker.io/${RepositoryName}/central-configuration:${ImageTag}-redhat
docker.io/${RepositoryName}/central-configuration:${ImageTag}-redhat-slim
docker.io/${RepositoryName}/xl-deploy:${ImageTag}-ubuntu
docker.io/${RepositoryName}/xl-deploy:${ImageTag}-ubuntu-slim
docker.io/${RepositoryName}/xl-deploy:${ImageTag}-redhat
docker.io/${RepositoryName}/xl-deploy:${ImageTag}-redhat-slim
docker.io/${RepositoryName}/deploy-task-engine:${ImageTag}-ubuntu
docker.io/${RepositoryName}/deploy-task-engine:${ImageTag}-ubuntu-slim
docker.io/${RepositoryName}/deploy-task-engine:${ImageTag}-redhat
docker.io/${RepositoryName}/deploy-task-engine:${ImageTag}-redhat-slim
docker.io/${RepositoryName}/xl-client:${ImageTag}
docker.io/${RemoteRunnerRepositoryName}/release-runner:${ImageTagRemoteRunner}
EOF

#!/bin/bash

# Read the YAML file and export the variables
while IFS=: read -r key value; do
  key=$(echo $key | xargs)  # Trim whitespace
  value=$(echo $value | xargs)  # Trim whitespace
  export $key=$value
done < ./xl-op/override-defaults.yaml

cat <<EOF
docker.io/${RepositoryNameRelease}/release-operator:${OperatorImageTagRelease}
docker.io/${RepositoryNameDeploy}/deploy-operator:${OperatorImageTagDeploy}
docker.io/${RepositoryNameRelease}/xl-release:${ImageTagRelease}-ubuntu
docker.io/${RepositoryNameRelease}/xl-release:${ImageTagRelease}-ubuntu-slim
docker.io/${RepositoryNameRelease}/xl-release:${ImageTagRelease}-redhat
docker.io/${RepositoryNameRelease}/xl-release:${ImageTagRelease}-redhat-slim
docker.io/${RepositoryNameDeploy}/central-configuration:${ImageTagDeploy}-ubuntu
docker.io/${RepositoryNameDeploy}/central-configuration:${ImageTagDeploy}-ubuntu-slim
docker.io/${RepositoryNameDeploy}/central-configuration:${ImageTagDeploy}-redhat
docker.io/${RepositoryNameDeploy}/central-configuration:${ImageTagDeploy}-redhat-slim
docker.io/${RepositoryNameDeploy}/xl-deploy:${ImageTagDeploy}-ubuntu
docker.io/${RepositoryNameDeploy}/xl-deploy:${ImageTagDeploy}-ubuntu-slim
docker.io/${RepositoryNameDeploy}/xl-deploy:${ImageTagDeploy}-redhat
docker.io/${RepositoryNameDeploy}/xl-deploy:${ImageTagDeploy}-redhat-slim
docker.io/${RepositoryNameDeploy}/deploy-task-engine:${ImageTagDeploy}-ubuntu
docker.io/${RepositoryNameDeploy}/deploy-task-engine:${ImageTagDeploy}-ubuntu-slim
docker.io/${RepositoryNameDeploy}/deploy-task-engine:${ImageTagDeploy}-redhat
docker.io/${RepositoryNameDeploy}/deploy-task-engine:${ImageTagDeploy}-redhat-slim
docker.io/${RepositoryNameRelease}/xl-client:${OperatorImageTagRelease}
docker.io/${RepositoryNameReleaseRunner}/release-runner:${ImageTagReleaseRunner}
EOF

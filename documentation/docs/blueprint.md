# Blueprint Parameters Documentation

## K8sSetup
**Prompt:** `Select the Kubernetes setup where the Digital.ai Devops Platform will be installed, updated or cleaned:`

**Type of Prompt:** Select

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Openshift**: Openshift
- **AWS EKS**: AWSEKS
- **Plain multi-node K8s cluster**: PlainK8s
- **Azure AKS**: AzureAKS
- **Google Kubernetes Engine**: GoogleGKE

**Default Value:** N/A

**Description:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to. Only the listed options are supported.


## OsType
**Prompt:** `The type of operating system where the xl command is running:`

**Type of Prompt:** Input

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** N/A


## ProcessType
**Prompt:** `The type of process command is running:`

**Type of Prompt:** Input

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** The type of process command which is running


## UseCustomNamespace
**Prompt:** `Do you want to use an custom Kubernetes namespace (current default is 'digitalai'):`

**Type of Prompt:** Confirm

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Type yes to use a namespace, not 'digitalai', in your kubernetes cluster for doing an install, update or clean of the Digital.ai Devops Platform.


## Namespace
**Prompt:** `Enter the name of the Kubernetes namespace where the Digital.ai DevOps Platform will be installed, updated or cleaned:`

**Type of Prompt:** Input

**Prompt Condition:** Type yes to use a namespace.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** digitalai

**Description:** Type the name of the Kubernetes namespace to install, update or clean the Digital.ai Devops Platform.


## CreateNamespace
**Prompt:** `Do you want to create custom Kubernetes namespace Namespace , it does not exist:`

**Type of Prompt:** Confirm

**Prompt Condition:** The type of process command which is running is not clean and k8sResource(type the name of the Kubernetes namespace to install, namespace, type the name of the Kubernetes namespace to install) is .

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** true

**Description:** Type yes to create a namespace in your kubernetes cluster.


## ServerType
**Prompt:** `Product server you want to perform ProcessType for:`

**Type of Prompt:** Select

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Digital.ai Release with optional Digital.ai Release Runner**: dai-release
- **Digital.ai Deploy**: dai-deploy
- **Digital.ai Release Runner**: dai-release-runner

**Default Value:** N/A

**Description:** Select product server you want to perform ProcessType for.


## CleanBefore
**Prompt:** `Should clean occur before the apply files to cluster:`

**Type of Prompt:** Confirm

**Prompt Condition:** N/A

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** N/A


## UpgradeType
**Prompt:** `Select the type of upgrade you want:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Operator to Operator**: operatorToOperator
- **Helm to Operator**: helmToOperator

**Default Value:** N/A

**Description:** Type of upgrade you want?


## ImageRegistryType
**Prompt:** `Select type of image registry:`

**Type of Prompt:** Select

**Prompt Condition:** The type of process command which is running is install or the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Default (Uses various public image registries for the installation images)**: default
- **Custom Public Registry (Uses a specific custom registry)**: public
- **Custom Private Registry - Password protected (Uses a specific custom registry with password)**: private

**Default Value:** default

**Description:** Select the type of the Image Registry to use for pulling all images required for the installation.


## CustomImageRegistryName
**Prompt:** `Enter the custom docker image registry name (eg: <imageRegistryName> from <imageRegistryName>/<repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Is Custom Image Repository and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** docker.io

**Description:** Enter the custom image registry name for pulling all the images required for this installation


## CustomPrivateImageRegistrySecret
**Prompt:** `Provide the custom docker image registry secret:`

**Type of Prompt:** Select

**Prompt Condition:** (select the type of the Image Registry to use for pulling all images required for the installation is private) and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'secrets')

**Default Value:** N/A

**Description:** Provide the imagePullSecrets name for the custom image registry


## RepositoryName
**Prompt:** `Enter the repository name for the application and operator images (eg: <repositoryName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Enter the repository name to use for the application and operator images


## ImageNameDeploy
**Prompt:** `Enter the Deploy server image name (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** xl-deploy

**Description:** Enter the Deploy server image name to use


## ImageNameRelease
**Prompt:** `Enter the Release image name (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** xl-release

**Description:** Enter the Release server image name to use


## ImageTag
**Prompt:** `Enter the application image tag (eg: <tagName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Enter the application server image tag to use


## ImageNameDeployTaskEngine
**Prompt:** `Enter the Deploy task engine image name for version 22 and above (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and not regex(^10.*$, enter the application server image tag to use) and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** deploy-task-engine

**Description:** Enter the Deploy task engine image name to use


## ImageNameCc
**Prompt:** `Enter the Central Configuration image name for version 22 and above (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and not regex(^10.*$, enter the application server image tag to use) and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** central-configuration

**Description:** Enter the Central Configuration image name to use


## LicenseSource
**Prompt:** `Select source of the license:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Generate the license (accepting EULA, this is only for temporary license)**: generate
- **Path to the license file (the file can be in clean text or base64 encoded)**: file
- **Copy/Paste the license to editor (the text can be in clean text or base64 encoded)**: editor

**Default Value:** generate

**Description:** Provide source of the license file


## LicenseEditor
**Prompt:** `Provide license for the server:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the license file is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide license for the server


## LicenseFile
**Prompt:** `Provide license file for the server:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the license file is file.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide license file for the server


## XldMasterCount
**Prompt:** `Enter the Deploy master replica count:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 3

**Description:** Enter the Deploy master server replica count. For production use 3 or above.


## PvcSizeDeploy
**Prompt:** `Enter PVC size for Deploy master (Gi):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 10

**Description:** Enter PVC size for Deploy master


## AccessModeDeploy
**Prompt:** `Select between supported Access Modes for the Deploy pods:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **ReadWriteOnce**: ReadWriteOnce
- **ReadWriteMany**: ReadWriteMany

**Default Value:** ReadWriteOnce

**Description:** Select between supported Access Modes to define if the volume can be mounted as read-write by a single node (ReadWriteOnce) or by many nodes (ReadWriteMany). For all Deploy pods ReadWriteOnce access mode is enough, the pods are not sharing the volumes.


## EnableSCC
**Prompt:** `Do you want to enable Security Context Constraints (SCCs)?`

**Type of Prompt:** Confirm

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is Openshift and select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** Openshift

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Security Context Constraints are disabled by default. If you are upgrading from a setup that had SCCs enabled, select 'yes' or configure them manually to avoid pod failures.


## XldWorkerCount
**Prompt:** `Enter the Deploy worker replica count:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 3

**Description:** Enter the Deploy worker replica count


## PvcSizeDeployTaskEngine
**Prompt:** `Enter PVC size for Deploy worker (Gi):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 10

**Description:** Enter PVC size for Deploy worker


## XlrReplicaCount
**Prompt:** `Enter the Release server replica count:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 3

**Description:** Enter the Release server replica count


## PvcSizeRelease
**Prompt:** `Enter PVC size for Release (Gi):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 8

**Description:** Enter PVC size for Release


## AccessModeRelease
**Prompt:** `Select between supported Access Modes for the Release pods (use ReadWriteMany if you plan to use multiple pods):`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **ReadWriteMany**: ReadWriteMany
- **ReadWriteOnce**: ReadWriteOnce

**Default Value:** ReadWriteMany

**Description:** Select between supported Access Modes to define if the volume can be mounted as read-write by a single node (ReadWriteOnce) or by many nodes (ReadWriteMany). For the Release pods if you plan to use multiple pods on different nodes use ReadWriteMany, the pods are sharing volumes.


## StorageClass
**Prompt:** `Provide storage class for the server:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'storageclasses')

**Default Value:** N/A

**Description:** Provide storage class for the server


## ResourcesSource
**Prompt:** `Select source of the resource values (CPU and memory):`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Predefined resource values**: preset
- **Custom resource values**: editor
- **None**: none

**Default Value:** none

**Description:** Provide source of the resources (CPU and memory) requests and limits values for various containers. This selection will be used for specifying resources for all the installation components


## ResourcesPresetDeploy
**Prompt:** `Select one of the predefined resource values for Deploy master:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 500m cpu, 1Gi memory. Limit - 1.0 cpu, 2Gi memory**: nano
- **Request - 1.0 cpu, 2Gi memory. Limit - 2.0 cpu, 4Gi memory**: micro
- **Request - 2.0 cpu, 5Gi memory. Limit - 4.0 cpu, 8Gi memory**: small
- **Request - 5.0 cpu, 10Gi memory. Limit - 8.0 cpu, 16Gi memory**: medium
- **Request - 10.0 cpu, 21Gi memory. Limit - 16.0 cpu, 32Gi memory**: large
- **Request - 21.0 cpu, 42Gi memory. Limit - 32.0 cpu, 64Gi memory**: xlarge
- **Request - 42.0 cpu, 85Gi memory. Limit - 64.0 cpu, 128Gi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Deploy master


## ResourcesEditorDeploy
**Prompt:** `Provide resource allocation for Deploy master:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Deploy master


## ResourcesPresetDeployCc
**Prompt:** `Select one of the predefined resource values for Central Configuration:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 250m cpu, 256Mi memory. Limit - 375m cpu, 384Mi memory**: nano
- **Request - 500m cpu, 512Mi memory. Limit - 750m cpu, 768Mi memory**: micro
- **Request - 500m cpu, 1Gi memory. Limit - 750m cpu, 1.5Gi memory**: small
- **Request - 1.0 cpu, 2Gi memory. Limit - 1.5 cpu, 3Gi memory**: medium
- **Request - 1.5 cpu, 4Gi memory. Limit - 3.0 cpu, 6Gi memory**: large
- **Request - 1.5 cpu, 4Gi memory. Limit - 6.0 cpu, 12Gi memory**: xlarge
- **Request - 1.5 cpu, 4Gi memory. Limit - 12.0 cpu, 24Gi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Central Configuration


## ResourcesEditorDeployCc
**Prompt:** `Provide resource allocation for Central Configuration:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Central Configuration


## ResourcesPresetDeployTaskEngine
**Prompt:** `Select one of the predefined resource values for Deploy worker:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 500m cpu, 1Gi memory. Limit - 1.0 cpu, 2Gi memory**: nano
- **Request - 1.0 cpu, 2Gi memory. Limit - 2.0 cpu, 4Gi memory**: micro
- **Request - 2.0 cpu, 5Gi memory. Limit - 4.0 cpu, 8Gi memory**: small
- **Request - 5.0 cpu, 10Gi memory. Limit - 8.0 cpu, 16Gi memory**: medium
- **Request - 10.0 cpu, 21Gi memory. Limit - 16.0 cpu, 32Gi memory**: large
- **Request - 21.0 cpu, 42Gi memory. Limit - 32.0 cpu, 64Gi memory**: xlarge
- **Request - 42.0 cpu, 85Gi memory. Limit - 64.0 cpu, 128Gi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Deploy worker


## ResourcesEditorDeployTaskEngine
**Prompt:** `Provide resource allocation for the Deploy worker:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Deploy worker


## ResourcesPresetRelease
**Prompt:** `Select one of the predefined resource values for Release server:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 500m cpu, 1Gi memory. Limit - 1.0 cpu, 2Gi memory**: nano
- **Request - 1.0 cpu, 2Gi memory. Limit - 2.0 cpu, 4Gi memory**: micro
- **Request - 2.0 cpu, 5Gi memory. Limit - 4.0 cpu, 8Gi memory**: small
- **Request - 5.0 cpu, 10Gi memory. Limit - 8.0 cpu, 16Gi memory**: medium
- **Request - 10.0 cpu, 21Gi memory. Limit - 16.0 cpu, 32Gi memory**: large
- **Request - 21.0 cpu, 42Gi memory. Limit - 32.0 cpu, 64Gi memory**: xlarge
- **Request - 42.0 cpu, 85Gi memory. Limit - 64.0 cpu, 128Gi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Release server


## ResourcesEditorRelease
**Prompt:** `Provide resource allocation for Release server:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Release server


## HttpProtocolRelease
**Prompt:** `Select Release server protocol:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **HTTP - not encrypted**: http
- **HTTPS - Secure HTTP**: https
- **HTTP2 - Secure HTTP2**: http2

**Default Value:** http

**Description:** Select the protocol, for https and https2 you will need to provide the secret with key, or you will use autogenerated self-signed key


## HttpProtocolDeploy
**Prompt:** `Select Deploy server protocol:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **HTTP - not encrypted**: http
- **HTTPS - Secure HTTP**: https

**Default Value:** http

**Description:** Select the protocol, for https and https2 you will need to provide the secret with key, or you will use autogenerated self-signed key


## ApplicationKeystoreSource
**Prompt:** `Select source of the HTTPS keystore for the server:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and (select the protocol is not http or select the protocol is not http).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **The HTTPS keystore will be automatically generated with self-signed key**: generate
- **Path to the HTTPS keystore file (the file can be in the raw format or base64 encoded)**: file
- **Copy/Paste the HTTPS keystore to editor (the content needs to be base64 encoded)**: editor
- **Generic Secret containing HTTPS keystore file in PKCS12 or JKS format**: secret

**Default Value:** generate

**Description:** Provide source of the HTTPS keystore in PKCS12 or JKS format


## ApplicationKeystoreEditor
**Prompt:** `Provide HTTPS keystore for the server:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the HTTPS keystore in PKCS12 or JKS format is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide HTTPS keystore for the server in pkcs12 format, generated with openssl


## ApplicationKeystoreFile
**Prompt:** `Provide HTTPS keystore file for the server:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the HTTPS keystore in PKCS12 or JKS format is file.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide the HTTPS keystore file for the server


## ApplicationKeystoreSecretName
**Prompt:** `Provide the generic secret name with the application server HTTPS keystore added in PKCS12 or JKS format:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the HTTPS keystore in PKCS12 or JKS format is secret.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'secrets')

**Default Value:** N/A

**Description:** Provide the Generic secret name with the HTTPS keystore for the application server. It must be in PKCS12 or JKS format.


## ApplicationKeystoreSecretKey
**Prompt:** `Provide the key from the provided secret that has HTTPS keystore:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the HTTPS keystore in PKCS12 or JKS format is secret.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** From the provided Generic secret provide key which contains the HTTPS keystore. It must be in PKCS12 or JKS format.


## ApplicationKeystoreType
**Prompt:** `Provide the application server HTTPS keystore format:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and (select the protocol is not http or select the protocol is not http).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **PKCS12**: pkcs12
- **JKS**: jks

**Default Value:** pkcs12

**Description:** Provide the HTTPS keystore type for the application server


## ApplicationKeystorePassword
**Prompt:** `Provide the server HTTPS keystore password:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and (select the protocol is not http or select the protocol is not http).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** HTTPS keystore passphrase for the server


## IngressTypeGeneric
**Prompt:** `Select between supported ingress types:`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is not Openshift and select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, PlainK8s

**Available Values:** 
- **NGINX**: nginx
- **HAProxy**: haproxy
- **External - IngressClass resource should already exist**: external
- **None - Ingress will not be set up during installation**: none

**Default Value:** nginx

**Description:** Select between supported ingress types. If None is selected, the application will not be exposed and therefore will not be accessible from the browser.


## IngressTypeOpenshift
**Prompt:** `Select between supported ingress types:`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is Openshift and select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** Openshift

**Available Values:** 
- **Openshift Route**: route
- **NGINX**: nginx
- **HAProxy**: haproxy
- **External - IngressClass resource should already exist**: external
- **None - Ingress will not be set up during installation**: none

**Default Value:** route

**Description:** Select between supported ingress types. If None is selected, the application will not be exposed and therefore will not be accessible from the browser.


## NginxResourcesPreset
**Prompt:** `Select one of the predefined resource values for Nginx ingress:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is nginx and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 100m cpu, 128Mi memory. Limit - 150m cpu, 192Mi memory**: nano
- **Request - 250m cpu, 256Mi memory. Limit - 375m cpu, 384Mi memory**: micro
- **Request - 500m cpu, 512Mi memory. Limit - 750m cpu, 768Mi memory**: small
- **Request - 500m cpu, 1024Mi memory. Limit - 750m cpu, 1536Mi memory**: medium
- **Request - 1.0 cpu, 2048Mi memory. Limit - 1.5 cpu, 3072Mi memory**: large
- **Request - 1.5 cpu, 4096Mi memory. Limit - 3.0 cpu, 6144Mi memory**: xlarge
- **Request - 1.5 cpu, 4096Mi memory. Limit - 6.0 cpu, 12288Mi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Nginx ingress


## NginxResourcesEditor
**Prompt:** `Provide resource allocation for Nginx ingress:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is nginx and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Nginx ingress


## HAProxyResourcesEditor
**Prompt:** `Provide resource allocation for HAProxy ingress:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is haproxy and provide source of the resources (CPU and memory) requests and limits values for various containers is not none.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for HAProxy ingress


## ExternalIngressClass
**Prompt:** `Provide external ingress class:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is external.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'ingressclasses')

**Default Value:** N/A

**Description:** External ingress class


## HttpProtocolIngress
**Prompt:** `Select ingress protocol:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is not none and select the protocol is http and select the protocol is http.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **HTTP - not encrypted**: http
- **HTTPS - enable an TLS/SSL ingress configuration**: https

**Default Value:** N/A

**Description:** Select the ingress protocol, for https you will need to provide the secret with key, or you will use autogenerated self-signed key


## IngressKeystoreSourceGeneric
**Prompt:** `Select source of the secure ingress keystore:`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is not Openshift and select product server you want to perform ProcessType for is not dai-release-runnerand the type of process command which is running is install and select between supported ingress types is not haproxy and select between supported ingress types is not none and select the ingress protocol is not http.

**Platform:** EKS, AKS, GKE, PlainK8s

**Available Values:** 
- **The ingress keystore will be automatically generated with self-signed key**: generate
- **TLS Secret containing tls key and cert**: secret
- **SSL passthrough (Cannot be chosen with backend protocol as http. It will pass the traffic to the backend without decryption. Application ssl keystore should be configured)**: passthrough

**Default Value:** generate

**Description:** Provide source of the ingress keystore


## IngressKeystoreSourceHaproxy
**Prompt:** `Select source of the secure ingress keystore:`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is not Openshift and select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is haproxy and select the ingress protocol is not http.

**Platform:** EKS, AKS, GKE, PlainK8s

**Available Values:** 
- **The ingress keystore will be automatically generated with self-signed key**: generate
- **TLS Secret containing tls key and cert**: secret

**Default Value:** generate

**Description:** Provide source of the ingress keystore


## IngressKeystoreSourceOpenshiftHttp
**Prompt:** `Select source of the keystore for the route:`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is Openshift and select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is not none and select the ingress protocol is not http and (select product server you want to perform ProcessType for is dai-release and select the protocol is http or select product server you want to perform ProcessType for is dai-deploy and select the protocol is http).

**Platform:** Openshift

**Available Values:** 
- **Use route default certificate**: default
- **The keystore will be automatically generated with self-signed key**: generate
- **TLS Secret containing tls key and cert**: secret
- **SSL passthrough (Cannot be choosen with backend protocol as http. It will pass the traffic to the backend without decryption. Application ssl keystore should be configured)**: passthrough

**Default Value:** default

**Description:** Provide source of the keystore


## IngressKeystoreSourceOpenshiftHttps
**Prompt:** `Select source of the keystore for the secure route (only passthrough is supported in case of the secure backend):`

**Type of Prompt:** Select

**Prompt Condition:** The flavour of Kubernetes to deploy or undeploy the Digital.ai Devops Platform to is Openshift and select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is not none and select the ingress protocol is not http and (select product server you want to perform ProcessType for is dai-release and select the protocol is not http or select product server you want to perform ProcessType for is dai-deploy and select the protocol is not http).

**Platform:** Openshift

**Available Values:** 
- **SSL passthrough (It will pass the traffic to the backend without decryption)**: passthrough

**Default Value:** passthrough

**Description:** Provide source of the keystore


## IngressHost
**Prompt:** `Provide DNS name for accessing UI of the server:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and (select between supported ingress types is not none or select product server you want to perform ProcessType for is dai-release).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide DNS name for accessing UI of the server. For OpenShift, this is used with Routing, while for other providers this is set up only when Ingress is used.


## HttpsProtocol
**Prompt:** `The access to the Release host will be secured externally with HTTPS protocol:`

**Type of Prompt:** Confirm

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install and select between supported ingress types is none and select the protocol is http.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Select true if the HTTPS protocol will be used that is setup somewhere externally, the server URL will start with https


## IngressTlsSecretName
**Prompt:** `Provide the TLS secret name with the key and certificate:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and select between supported ingress types is not none and select the ingress protocol is not http and select between supported ingress keystore sources is secret.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'secrets')

**Default Value:** N/A

**Description:** Provide the TLS secret name with the key and certificate


## AdminPassword
**Prompt:** `Provide administrator password:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Administrator password


## OidcConfigTypeInstall
**Prompt:** `Type of the OIDC configuration:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **No OIDC Configuration**: no-oidc
- **External OIDC Configuration**: external
- **Identity Service Configuration**: identity-service

**Default Value:** no-oidc

**Description:** Provide the type of the OIDC configuration


## OidcConfigTypeUpgrade
**Prompt:** `Type of the OIDC configuration:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Existing OIDC Configuration**: existing
- **No OIDC Configuration**: no-oidc
- **External OIDC Configuration**: external
- **Identity Service Configuration**: identity-service

**Default Value:** existing

**Description:** Provide the type of the OIDC configuration


## ExternalOidcConfGenericDeploy
**Prompt:** `Configure external oidc setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of the OIDC configuration is external and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
accessTokenUri: ""
clientId: ""
clientSecret: ""
emailClaim: ""
issuer: ""
keyRetrievalUri: ""
logoutUri: ""
postLogoutRedirectUri: ""
redirectUri: ""
rolesClaimName: ""
userAuthorizationUri: ""
userNameClaimName: ""
fullNameClaim: ""
scopes: '["openid"]'
```

**Description:** N/A


## ExternalOidcConfGenericRelease
**Prompt:** `Configure external oidc setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of the OIDC configuration is external and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
accessTokenUri: ""
clientId: ""
clientSecret: ""
emailClaim: ""
fullNameClaim: ""
issuer: ""
keyRetrievalUri: ""
logoutUri: ""
postLogoutRedirectUri: ""
redirectUri: ""
rolesClaim: ""
userAuthorizationUri: ""
userNameClaim: ""
scopes: '["openid"]'
```

**Description:** N/A


## IdentityServiceConfDeploy
**Prompt:** `Configure Identity Service setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of the OIDC configuration is identity-service and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
clientId: ""
clientSecret: ""
issuer: ""
redirectUri: ""
postLogoutRedirectUri: ""
rolesClaimName: ""
userNameClaimName: "preferred_username"
scopes: ["openid"]
```

**Description:** N/A


## IdentityServiceConfRelease
**Prompt:** `Configure Identity Service setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of the OIDC configuration is identity-service and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
clientId: ""
clientSecret: ""
issuer: ""
redirectUri: ""
postLogoutRedirectUri: ""
rolesClaim: ""
userNameClaim: "preferred_username"
scopes: ["openid"]
```

**Description:** N/A


## OperatorImageDeploy
**Prompt:** `Enter the operator image to use (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** deploy-operator

**Description:** Enter the operator image to use


## OperatorImageRelease
**Prompt:** `Enter the operator image to use (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** release-operator

**Description:** Enter the operator image to use


## OperatorImageTag
**Prompt:** `Enter the operator image tag (eg: <tagName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Enter the operator image tag to use


## RepositoryKeystoreSource
**Prompt:** `Select source of the repository keystore:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Generate the repository keystore during installation (you need to have keytool utility installed in your path)**: generate
- **Path to the repository keystore file (the file can be in the raw format or base64 encoded)**: file
- **Copy/Paste the repository keystore to editor (the content needs to be base64 encoded)**: editor
- **Default repository keystore**: default

**Default Value:** generate

**Description:** Provide source of the repository keystore file


## RepositoryKeystoreEditor
**Prompt:** `Provide repository keystore for the server:`

**Type of Prompt:** Editor

**Prompt Condition:** The type of process command which is running is install and provide source of the repository keystore file is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide repository keystore for the server, generated with: `keytool -genseckey -alias deployit-passsword-key -keyalg aes -keysize 128 -keypass deployit -keystore repository-keystore.jceks -storetype jceks -storepass <KeystorePassphrase>`


## RepositoryKeystoreFile
**Prompt:** `Provide repository keystore for the server:`

**Type of Prompt:** Input

**Prompt Condition:** The type of process command which is running is install and provide source of the repository keystore file is file.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide repository keystore for the server, generated with: `keytool -genseckey -alias deployit-passsword-key -keyalg aes -keysize 128 -keypass deployit -keystore repository-keystore.jceks -storetype jceks -storepass <KeystorePassphrase>`


## KeystorePassphrase
**Prompt:** `Provide repository keystore passphrase:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install and provide source of the repository keystore file is not default.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Repository keystore passphrase for the server


## EnablePostgresql
**Prompt:** `Do you want to install a new PostgreSQL on the cluster:`

**Type of Prompt:** Confirm

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Select 'yes' to install a new PostgreSQL instance using the subchart, or 'no' to configure an existing supported database instance.


## PostgresqlStorageClass
**Prompt:** `Provide Storage Class to be defined for PostgreSQL:`

**Type of Prompt:** Select

**Prompt Condition:** The type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'storageclasses')

**Default Value:** N/A

**Description:** Provide Storage Class to be defined for PostgreSQL


## PostgresqlPvcSize
**Prompt:** `Provide PVC size for PostgreSQL (Gi):`

**Type of Prompt:** Input

**Prompt Condition:** The type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 8

**Description:** Provide PVC size for PostgreSQL


## PostgresqlResourcesPreset
**Prompt:** `Select one of the predefined resource values for Postgresql:`

**Type of Prompt:** Select

**Prompt Condition:** The type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 100m cpu, 128Mi memory. Limit - 150m cpu, 192Mi memory**: nano
- **Request - 250m cpu, 256Mi memory. Limit - 375m cpu, 384Mi memory**: micro
- **Request - 500m cpu, 512Mi memory. Limit - 750m cpu, 768Mi memory**: small
- **Request - 500m cpu, 1024Mi memory. Limit - 750m cpu, 1536Mi memory**: medium
- **Request - 1.0 cpu, 2048Mi memory. Limit - 1.5 cpu, 3072Mi memory**: large
- **Request - 1.5 cpu, 4096Mi memory. Limit - 3.0 cpu, 6144Mi memory**: xlarge
- **Request - 1.5 cpu, 4096Mi memory. Limit - 6.0 cpu, 12288Mi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Postgresql


## PostgresqlResourcesEditor
**Prompt:** `Provide resource allocation for Postgresql:`

**Type of Prompt:** Editor

**Prompt Condition:** The type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Postgresql


## PostgresqlExternalConfigRelease
**Prompt:** `Edit database external setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart is false.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
main:
  url: jdbc:postgresql://<xlr-db-host>:5432/<xlr-database-name>
  username: <xlr-username>
  password: |-
    <xlr-password>
  maxPoolSize: 10
report:
  url: jdbc:postgresql://<xlr-report-db-host>:5432/<xlr-report-database-name>
  username: <xlr-report-username>
  password: |-
    <xlr-report-password>
  maxPoolSize: 10
```

**Description:** Setup the PostgreSQL external parameters (JDBC URL, username, password)


## PostgresqlExternalConfigDeploy
**Prompt:** `Edit database external setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and select yes to install a new PostgreSQL instance using the subchart is false.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
main:
  url: jdbc:postgresql://<xld-db-host>:5432/<xld-database-name>
  username: <xld-username>
  password: |-
    <xld-password>
  maxPoolSize: 10
report:
  url: jdbc:postgresql://<xld-report-db-host>:5432/<xld-report-database-name>
  username: <xld-report-username>
  password: |-
    <xld-report-password>
  maxPoolSize: 10
```

**Description:** Setup the PostgreSQL external parameters (JDBC URL, username, password)


## EnableRabbitmq
**Prompt:** `Do you want to install a new RabbitMQ on the cluster:`

**Type of Prompt:** Confirm

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Select 'yes' to install a new RabbitMQ instance using the subchart, or 'no' to configure an existing supported MQ instance.


## RabbitmqReplicaCount
**Prompt:** `Replica count to be defined for RabbitMQ:`

**Type of Prompt:** Input

**Prompt Condition:** The type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 3

**Description:** Replica count to be defined for RabbitMQ


## RabbitmqStorageClass
**Prompt:** `Storage Class to be defined for RabbitMQ:`

**Type of Prompt:** Select

**Prompt Condition:** The type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'storageclasses')

**Default Value:** N/A

**Description:** Storage Class to be defined for RabbitMQ


## RabbitmqPvcSize
**Prompt:** `Provide PVC size for RabbitMQ (Gi):`

**Type of Prompt:** Input

**Prompt Condition:** The type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 8

**Description:** Provide PVC size for RabbitMQ


## RabbitmqResourcesPreset
**Prompt:** `Select one of the predefined resource values for Rabbitmq:`

**Type of Prompt:** Select

**Prompt Condition:** The type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart and provide source of the resources (CPU and memory) requests and limits values for various containers is preset.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Request - 100m cpu, 128Mi memory. Limit - 150m cpu, 192Mi memory**: nano
- **Request - 250m cpu, 256Mi memory. Limit - 375m cpu, 384Mi memory**: micro
- **Request - 500m cpu, 512Mi memory. Limit - 750m cpu, 768Mi memory**: small
- **Request - 500m cpu, 1024Mi memory. Limit - 750m cpu, 1536Mi memory**: medium
- **Request - 1.0 cpu, 2048Mi memory. Limit - 1.5 cpu, 3072Mi memory**: large
- **Request - 1.5 cpu, 4096Mi memory. Limit - 3.0 cpu, 6144Mi memory**: xlarge
- **Request - 1.5 cpu, 4096Mi memory. Limit - 6.0 cpu, 12288Mi memory**: 2xlarge

**Default Value:** nano

**Description:** Select one of the predefined resource values for Rabbitmq


## RabbitmqResourcesEditor
**Prompt:** `Provide resource allocation for Rabbitmq:`

**Type of Prompt:** Editor

**Prompt Condition:** The type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart and provide source of the resources (CPU and memory) requests and limits values for various containers is editor.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Provide resource allocation for Rabbitmq


## RabbitmqExternalConfigRelease
**Prompt:** `Edit RabbitMQ external setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart is false.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
url: <queue-url>
queueName: <queue-name>
username: <username>
password: |-
  <password>
queueType: <classic-or-quorum>
connector: <rabbitmq-jms-or-activemq-jms>
```

**Description:** Setup the RabbitMQ external parameters


## RabbitmqExternalConfigDeploy
**Prompt:** `Edit RabbitMQ external setup:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is install and select yes to install a new RabbitMQ instance using the subchart is false.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
url: <queue-url>
queueName: <queue-name>
username: <username>
password: |-
  <password>
driverClassName: <driver-class-name>
queueType: <classic-or-quorum>
```

**Description:** Setup the RabbitMQ external parameters


## CrdName
**Prompt:** `Enter the name of custom resource definition you want to reuse or replace:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and ((CleanBefore or the type of process command which is running is clean) and length(k8sResources(type the name of the Kubernetes namespace to install, crd, , short product server used for filtering in the blueprints)) is not 0) or (the type of process command which is running is upgrade and type of upgrade you want? is operatorToOperator and the name of custom resource definition that you want to reuse or replace (delete) is ).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, 'crd')

**Default Value:** N/A

**Description:** The name of custom resource definition that you want to reuse or replace (delete).


## IsCrdReused
**Prompt:** `Should CRD be reused, if No we will delete the CRD CrdName , and all related CRs will be deleted with it:`

**Type of Prompt:** Confirm

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and (CleanBefore or the type of process command which is running is clean or the type of process command which is running is upgrade) and the name of custom resource definition that you want to reuse or replace (delete) is not .

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Should CRD be reused? If Yes it will not be deleted, if No we will delete the CRD CrdName , and all related CRs will be deleted with it. Put Yes if you have on the same cluster multiple installation of the ServerType


## CrName
**Prompt:** `Enter the name of custom resource:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and ((the name of custom resource definition that you want to reuse or replace (delete) is not  and (CleanBefore or the type of process command which is running is clean) and length(k8sResources(type the name of the Kubernetes namespace to install, the name of custom resource definition that you want to reuse or replace (delete))) is not 0) or (the type of process command which is running is upgrade and type of upgrade you want? is operatorToOperator and the name of your custom resource is )).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- k8sResources(Namespace, CrdName)

**Default Value:** N/A

**Description:** The name of your custom resource


## PreserveCrValuesDeploy
**Prompt:** `Edit list of custom resource keys that will migrate to the new Deploy CR:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-deploy and the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
.metadata.name: .
.spec.centralConfiguration.persistence.storageClass:
  0.0: .spec.Persistence.StorageClass
  23.3: .
.spec.master.persistence.storageClass:
  0.0: .spec.Persistence.StorageClass
  23.3: .
.spec.worker.persistence.storageClass:
  0.0: .spec.Persistence.StorageClass
  23.3: .
.spec.auth.adminPassword:
  0.0: .spec.AdminPassword
  23.3: .
.spec.centralConfiguration.replicaCount: .
.spec.centralConfiguration.persistence.paths: .
.spec.centralConfiguration.persistence.emptyDirPaths: .
.spec.centralConfiguration.persistence.accessModes[0]:
  0.0: .spec.Persistence.AccessMode
  23.3:
.spec.centralConfiguration.persistence.accessModes:
  0.0:
  23.3: .
.spec.centralConfiguration.persistence.size:
  0.0: .spec.centralConfiguration.persistence.pvcSize
  23.3: .
.spec.centralConfiguration.persistence.existingClaim:
  0.0:
    existance: .spec.deploy.centralConfiguration.persistence.existingClaim
    expression: .spec.deploy.centralConfiguration.persistence.existingClaim
  23.3: .
.spec.centralConfiguration.migrateFromEmbedded: .
.spec.master.replicaCount:
  0.0: .spec.XldMasterCount
  23.3: .
.spec.master.persistence.paths: .
.spec.master.persistence.emptyDirPaths: .
.spec.master.persistence.accessModes[0]:
  0.0: .spec.Persistence.AccessMode
  23.3:
.spec.master.persistence.accessModes:
  0.0:
  23.3: .
.spec.master.persistence.size:
  0.0: .spec.Persistence.XldMasterPvcSize
  23.3: .
.spec.master.persistence.existingClaim:
  0.0:
    existance: .spec.deploy.master.persistence.existingClaim
    expression: .spec.deploy.master.persistence.existingClaim
  23.3: .
.spec.worker.replicaCount:
  0.0: .spec.XldWorkerCount
  23.3: .
.spec.worker.persistence.paths: .
.spec.worker.persistence.emptyDirPaths: .
.spec.worker.persistence.accessModes[0]:
  0.0: .spec.Persistence.AccessMode
  23.3:
.spec.worker.persistence.accessModes:
  0.0:
  23.3: .
.spec.worker.persistence.size:
  0.0: .spec.Persistence.XldWorkerPvcSize
  23.3: .
.spec.worker.persistence.existingClaim:
  0.0:
    existance: .spec.deploy.worker.persistence.existingClaim
    expression: .spec.deploy.worker.persistence.existingClaim
  23.3: .
.spec.oidc: .
.spec.external.db:
  0.0:
  23.3: .
.spec.external.db.enabled:
  0.0: .spec.UseExistingDB.Enabled
  23.3:
.spec.external.db.main.url:
  0.0: .spec.UseExistingDB.XL_DB_URL
  23.3:
.spec.external.db.main.username:
  0.0: .spec.UseExistingDB.XL_DB_USERNAME
  23.3:
.spec.external.db.main.password:
  0.0: .spec.UseExistingDB.XL_DB_PASSWORD
  23.3:
.spec.external.db.report.url:
  0.0: .spec.UseExistingDB.XL_REPORT_DB_URL // .spec.UseExistingDB.XL_DB_URL
  23.3:
.spec.external.db.report.username:
  0.0: .spec.UseExistingDB.XL_REPORT_DB_USER // .spec.UseExistingDB.XL_REPORT_DB_USERNAME // .spec.UseExistingDB.XL_DB_USERNAME
  23.3:
.spec.external.db.report.password:
  0.0: .spec.UseExistingDB.XL_REPORT_DB_PASS // .spec.UseExistingDB.XL_REPORT_DB_PASSWORD // .spec.UseExistingDB.XL_DB_PASSWORD
  23.3:
.spec.external.mq:
  0.0:
  23.3: .
.spec.external.mq.enabled:
  0.0: .spec.UseExistingMQ.Enabled
  23.3:
.spec.external.mq.url:
  0.0: .spec.UseExistingMQ.XLD_TASK_QUEUE_URL
  23.3:
.spec.external.mq.username:
  0.0: .spec.UseExistingMQ.XLD_TASK_QUEUE_USERNAME
  23.3:
.spec.external.mq.password:
  0.0: .spec.UseExistingMQ.XLD_TASK_QUEUE_PASSWORD
  23.3:
.spec.external.mq.driverClassName:
  0.0: .spec.UseExistingMQ.XLD_TASK_QUEUE_DRIVER_CLASS_NAME
  23.3:
.spec.ingress.enabled:
  0.0: .spec.ingress.Enabled
  23.3: .
.spec.ingress.hostname:
  0.0: .spec.ingress.hosts.[0]
  23.3: .
.spec.ingress.path: .
.spec.ingress.annotations: .
.spec.ingress.extraTls:
  0.0: .spec.ingress.tls
  23.3: .
.spec.keystore.passphrase:
  0.0: .spec.KeystorePassphrase
  23.3: .
.spec.keystore.keystore:
  0.0: .spec.RepositoryKeystore
  23.3: .
.spec.truststore: .
.spec.postgresql.install: .
.spec.postgresql.primary.persistence.size:
  0.0: .spec.postgresql.persistence.size
  23.3: .
.spec.postgresql.global.storageClass:
  0.0: .spec.postgresql.persistence.storageClass
  23.3: .
.spec.postgresql.primary.persistence.storageClass:
  0.0: .spec.postgresql.persistence.storageClass
  23.3: .
.spec.postgresql.primary.extendedConfiguration:
  0.0:
    existance: .spec.postgresql.postgresqlMaxConnections
    expression: .spec.postgresql.postgresqlMaxConnections as $maxConnection | "max_connections = " + $maxConnection
  23.3: .
.spec.postgresql.hasReport:
  0.0: .spec.postgresql.hasReport // false
  23.3: .
# preserve current DB version
.spec.postgresql.image.tag: .
.spec.haproxy-ingress.install: .
.spec.nginx-ingress-controller.install: .
.spec.rabbitmq.install: .
.spec.rabbitmq.persistence.storageClass: .
.spec.rabbitmq.persistence.size: .
.spec.rabbitmq.replicaCount: .
.spec.rabbitmq.persistence.replicaCount: .
# upgrade to next supported MQ version (do the manual upgrade later)
.spec.rabbitmq.image.tag:
  0.0:
    existance: .spec.rabbitmq.image.tag
    expression: .spec.rabbitmq.image.updateTag // "3.10.25"
  23.3: .
.spec.route.hostname:
  0.0: .spec.route.hosts.[0]
  23.3: .
.spec.route.path: .
.spec.route.annotations: .
.spec.route.tls: .
.spec.route.enabled:
  0.0: .spec.route.Enabled
  23.3: .
.spec.license:
  0.0: .spec.xldLicense
  23.3: .
.spec.licenseAcceptEula:
  0.0:
  23.3: .
.spec.ssl: .
.spec.hooks: .
.spec.centralConfiguration.configuration: .
.spec.centralConfiguration.extraConfiguration: .
.spec.master.configuration: .
.spec.master.extraConfiguration: .
.spec.worker.configuration: .
.spec.worker.extraConfiguration: .
.spec.postgresql.primary.configuration: .
.spec.postgresql.primary.extraConfiguration: .
.spec.rabbitmq.configuration: .
.spec.rabbitmq.extraConfiguration: .
.spec.centralConfiguration.resourcesPreset: .
.spec.centralConfiguration.resources: .
.spec.centralConfiguration.defaultInitContainers.resources: .
.spec.master.resourcesPreset: .
.spec.master.resources: .
.spec.master.defaultInitContainers.resources: .
.spec.worker.resourcesPreset: .
.spec.worker.resources: .
.spec.worker.defaultInitContainers.resources: .
.spec.haproxy-ingress.resources: .
.spec.nginx-ingress-controller.defaultBackend.resources: .
.spec.nginx-ingress-controller.defaultBackend.resourcesPreset: .
.spec.nginx-ingress-controller.resources: .
.spec.nginx-ingress-controller.resourcesPreset: .
.spec.postgresql.primary.resources: .
.spec.postgresql.primary.resourcesPreset: .
.spec.rabbitmq.resources: .
.spec.rabbitmq.resourcesPreset: .
.spec.centralConfiguration.podSecurityContext: .
.spec.centralConfiguration.containerSecurityContext: .
.spec.centralConfiguration.volumePermissions: .
.spec.master.podSecurityContext: .
.spec.master.containerSecurityContext: .
.spec.master.volumePermissions: .
.spec.worker.podSecurityContext: .
.spec.worker.containerSecurityContext: .
.spec.worker.volumePermissions: .
.spec.haproxy-ingress.controller.securityContext: .
.spec.postgresql.primary.containerSecurityContext: .
.spec.postgresql.primary.podSecurityContext: .
.spec.postgresql.volumePermissions: .
.spec.rabbitmq.containerSecurityContext: .
.spec.rabbitmq.podSecurityContext: .
.spec.rabbitmq.volumePermissions: .
```

**Description:** For all matched expressions in the cluster CR, the values will be migrated to the upgraded Deploy CR


## PreserveCrValuesRelease
**Prompt:** `Edit list of custom resource keys that will migrate to the new Release CR:`

**Type of Prompt:** Editor

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:**
```
.metadata.name: .
.spec.persistence.storageClass:
  0.0: .spec.Persistence.StorageClass
  23.3: .
.spec.auth.adminPassword:
  0.0: .spec.AdminPassword
  23.3: .
.spec.appProtocol:
  0.0:
  23.3: .
.spec.appHostname:
  0.0:
  23.3: .
.spec.replicaCount: .
.spec.persistence.paths: .
.spec.persistence.emptyDirPaths: .
.spec.persistence.accessModes.[0]:
  0.0: .spec.Persistence.AccessMode
  23.3:
.spec.persistence.accessModes:
  0.0:
  23.3: .
.spec.persistence.size:
  0.0: .spec.Persistence.Size
  23.3: .
.spec.persistence.existingClaim:
  0.0:
    existance: .spec.Persistence.ExistingClaim
    expression: .spec.Persistence.ExistingClaim
  23.3: .
.spec.oidc: .
.spec.external.db:
  0.0:
  23.3: .
.spec.external.db.enabled:
  0.0: .spec.UseExistingDB.Enabled
  23.3:
.spec.external.db.main.url:
  0.0: .spec.UseExistingDB.XLR_DB_URL
  23.3:
.spec.external.db.main.username:
  0.0: .spec.UseExistingDB.XLR_DB_USER
  23.3:
.spec.external.db.main.password:
  0.0: .spec.UseExistingDB.XLR_DB_PASS
  23.3:
.spec.external.db.report.url:
  0.0: .spec.UseExistingDB.XLR_REPORT_DB_URL
  23.3:
.spec.external.db.report.username:
  0.0: .spec.UseExistingDB.XLR_REPORT_DB_USER
  23.3:
.spec.external.db.report.password:
  0.0: .spec.UseExistingDB.XLR_REPORT_DB_PASS
  23.3:
.spec.external.mq:
  0.0:
  23.3: .
.spec.external.mq.enabled:
  0.0: .spec.UseExistingMQ.Enabled
  23.3:
.spec.external.mq.url:
  0.0: .spec.UseExistingMQ.XLR_TASK_QUEUE_URL
  23.3:
.spec.external.mq.queueName:
  0.0: .spec.UseExistingMQ.XLR_TASK_QUEUE_NAME
  23.3:
.spec.external.mq.username:
  0.0: .spec.UseExistingMQ.XLR_TASK_QUEUE_USERNAME
  23.3:
.spec.external.mq.password:
  0.0: .spec.UseExistingMQ.XLR_TASK_QUEUE_PASSWORD
  23.3:
.spec.ingress.enabled:
  0.0: .spec.ingress.Enabled
  23.3: .
.spec.ingress.hostname:
  0.0: .spec.ingress.hosts.[0]
  23.3: .
.spec.ingress.path: .
.spec.ingress.annotations: .
.spec.ingress.extraTls:
  0.0: .spec.ingress.tls
  23.3: .
.spec.keystore.passphrase:
  0.0: .spec.KeystorePassphrase
  23.3: .
.spec.keystore.keystore:
  0.0: .spec.RepositoryKeystore
  23.3: .
.spec.truststore: .
.spec.postgresql.install: .
.spec.postgresql.primary.persistence.size:
  0.0: .spec.postgresql.persistence.size
  23.3: .
.spec.postgresql.global.storageClass:
  0.0: .spec.postgresql.persistence.storageClass
  23.3: .
.spec.postgresql.primary.persistence.storageClass:
  0.0: .spec.postgresql.persistence.storageClass
  23.3: .
.spec.postgresql.primary.extendedConfiguration:
  0.0:
    existance: .spec.postgresql.postgresqlMaxConnections
    expression: .spec.postgresql.postgresqlMaxConnections as $maxConnection | "max_connections = " + $maxConnection
  23.3: .
# preserve current DB version
.spec.postgresql.image.tag: .
.spec.haproxy-ingress.install: .
.spec.nginx-ingress-controller.install: .
.spec.rabbitmq.install: .
.spec.rabbitmq.persistence.storageClass: .
.spec.rabbitmq.persistence.size: .
.spec.rabbitmq.replicaCount: .
.spec.rabbitmq.persistence.replicaCount: .
# upgrade to next supported MQ version (do the manual upgrade later)
.spec.rabbitmq.image.tag:
  0.0:
    existance: .spec.rabbitmq.image.tag
    expression: .spec.rabbitmq.image.updateTag // "3.10.25"
  23.3: .
.spec.route.hostname:
  0.0: .spec.route.hosts.[0]
  23.3: .
.spec.route.path: .
.spec.route.annotations: .
.spec.route.tls: .
.spec.route.enabled:
  0.0: .spec.route.Enabled
  23.3: .
.spec.license:
  0.0: .spec.xlrLicense
  23.3: .
.spec.licenseAcceptEula:
  0.0:
  23.3: .
.spec.http2.enabled: .
.spec.ssl: .
.spec.hooks: .
.spec.configuration: .
.spec.extraConfiguration: .
.spec.postgresql.primary.configuration: .
.spec.postgresql.primary.extraConfiguration: .
.spec.rabbitmq.configuration: .
.spec.rabbitmq.extraConfiguration: .
.spec.resourcesPreset: .
.spec.resources: .
.spec.defaultInitContainers.resources: .
.spec.haproxy-ingress.resources: .
.spec.nginx-ingress-controller.defaultBackend.resources: .
.spec.nginx-ingress-controller.defaultBackend.resourcesPreset: .
.spec.nginx-ingress-controller.resources: .
.spec.nginx-ingress-controller.resourcesPreset: .
.spec.postgresql.primary.resources: .
.spec.postgresql.primary.resourcesPreset: .
.spec.rabbitmq.resources: .
.spec.rabbitmq.resourcesPreset: .
.spec.podSecurityContext: .
.spec.containerSecurityContext: .
.spec.volumePermissions: .
.spec.haproxy-ingress.controller.securityContext: .
.spec.postgresql.primary.containerSecurityContext: .
.spec.postgresql.primary.podSecurityContext: .
.spec.postgresql.volumePermissions: .
.spec.rabbitmq.containerSecurityContext: .
.spec.rabbitmq.podSecurityContext: .
.spec.rabbitmq.volumePermissions: .
```

**Description:** For all matched expressions in the cluster CR, the values will be migrated to the upgraded Release CR


## PreservePvc
**Prompt:** `Should we preserve persisted volume claims? If not all volume data will be lost:`

**Type of Prompt:** Confirm

**Prompt Condition:** (the type of process command which is running is clean or CleanBefore) and select product server you want to perform ProcessType for is not dai-release-runner.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** If yes the PVC will remain and not deleted


## ReleaseName
**Prompt:** `Enter the helm release name:`

**Type of Prompt:** Input

**Prompt Condition:** Select product server you want to perform ProcessType for is not dai-release-runner and type of upgrade you want? is helmToOperator and the type of process command which is running is upgrade.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** The name of your custom resource definition.


## RemoteRunnerInstallType
**Prompt:** `Install Digital.ai Release Runner:`

**Type of Prompt:** Select

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and the type of process command which is running is install.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **Don't install Digital.ai Release Runner**: no-install
- **Install Release Runner from local setup**: local-install
- **Install Release Runner on the cluster**: cluster-install

**Default Value:** N/A

**Description:** Type yes to install Digital.ai Release Runner. The installation will start after Release is ready on the cluster.


## RemoteRunnerRepositoryName
**Prompt:** `Enter the Release Runner repository name (eg: <repositoryName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Enter the Release Runner repository name to use


## ImageNameRemoteRunner
**Prompt:** `Enter the Release Runner image name (eg: <imageName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** release-runner

**Description:** Enter the Release Runner image name to use


## ImageTagRemoteRunner
**Prompt:** `Enter the Release Runner image tag (eg: <tagName> from <repositoryName>/<imageName>:<tagName>):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Enter the Release Runner image tag to use


## RemoteRunnerReleaseName
**Prompt:** `Enter the Release Runner Helm Chart release name:`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and select product server you want to perform ProcessType for is dai-release-runner.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** release-runner

**Description:** Release Runner Helm Chart release name that will be used with helm command during installation.


## RemoteRunnerUseDefaultLocation
**Prompt:** `Use default version of the Release Runner helm chart:`

**Type of Prompt:** Confirm

**Prompt Condition:** RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** true

**Description:** Type yes to use default internal version of the Release Runner helm chart, in other way you need to provide path to the helm chart.


## RemoteRunnerHelmChartUrl
**Prompt:** `Enter the Release Runner Helm Chart path (URL or local path):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and not type yes to use default internal version of the Release Runner helm chart and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** Release Runner Helm Chart local filesystem path or URL to the Release Runner Helm Chart package.


## RemoteRunnerGeneration
**Prompt:** `Do Release Runner generation:`

**Type of Prompt:** Confirm

**Prompt Condition:** False.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Generation date and time.


## RemoteRunnerReleaseUrl
**Prompt:** `Enter the Release URL that will be used by Release Runner:`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and type yes to install Digital.ai Release Runner is not cluster-install and (select product server you want to perform ProcessType for is dai-release-runner or generation date and time) and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** The Release URL that will be used by Release Runner, it needs to be accessible from the Release Runner pod.


## RemoteRunnerUserEmail
**Prompt:** `Provide release-runner user email (for the user on the Release to send PAT expiration notifications):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** release-runner@no.reply

**Description:** release-runner user is user on the Release, that will be used to generate Personal Access Token. The email will be used to send PAT expiration notifications.


## RemoteRunnerUserPassword
**Prompt:** `Provide release-runner user password (user on the Release):`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** release-runner user is user on the Release, that will be used to generate Personal Access Token.


## RemoteRunnerTokenExpiration
**Prompt:** `Release Runner token expiration:`

**Type of Prompt:** Select

**Prompt Condition:** RemoteRunnerInstall and select product server you want to perform ProcessType for is not dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** 
- **No expiration**: 0
- **30 days**: 30
- **60 days**: 60
- **1 year**: 365

**Default Value:** N/A

**Description:** Provide Release Runner token expiration


## RemoteRunnerToken
**Prompt:** `Enter the Release Token that will be used by Release Runner:`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and type yes to install Digital.ai Release Runner is not cluster-install and (select product server you want to perform ProcessType for is dai-release-runner or generation date and time) and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** To get the Release Token you need to login on the Release and generate Personal access token. Check the Release URL: RemoteRunnerReleaseUrl /#/personal-access-token


## RemoteRunnerCount
**Prompt:** `Enter the Release Runner replica count:`

**Type of Prompt:** Input

**Prompt Condition:** RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** 1

**Description:** Enter the Release Runner replica count, it will spin given number of replicas


## IsRemoteRunnerTruststoreEnabled
**Prompt:** `Enable truststore for Release Runner:`

**Type of Prompt:** Confirm

**Prompt Condition:** RemoteRunnerInstall and select product server you want to perform ProcessType for is dai-release-runner and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Type yes to setup truststore for Release Runner


## RemoteRunnerTruststore
**Prompt:** `Provide base64 encoded PKCS12 truststore:`

**Type of Prompt:** Editor

**Prompt Condition:** Type yes to setup truststore for Release Runner and RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** The Release Runner truststore with the trusted certificates. Accepted is PKCS12 format.


## RemoteRunnerTruststorePassword
**Prompt:** `Provide truststore password:`

**Type of Prompt:** Input

**Prompt Condition:** Type yes to setup truststore for Release Runner and RemoteRunnerInstall and (the type of process command which is running is install or the type of process command which is running is upgrade).

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** N/A

**Default Value:** N/A

**Description:** The Release Runner truststore password


## RemoteRunnerClean
**Prompt:** `Clean Release Runner from Digital.ai Release?:`

**Type of Prompt:** Confirm

**Prompt Condition:** Select product server you want to perform ProcessType for is dai-release and (CleanBefore or the type of process command which is running is clean) and length(k8sResources(type the name of the Kubernetes namespace to install, sts, release Runner Helm Chart release name that will be used with helm command during installation)) greater than 0.

**Platform:** EKS, AKS, GKE, Openshift, PlainK8s

**Available Values:** Yes/No

**Default Value:** N/A

**Description:** Type yes to delete Digital.ai Release Runner. The cleanup will be performed alongside Release cleanup.



## Helm 

![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)


### Core Helm Terminology


##### 1. Helm Chart
A bundle of pre-configured Kubernetes resources and YAML manifests (such as Deployments, Services, Ingresses, and ConfigMaps) packaged together. It serves as the single reusable blueprint for an application.

##### 2. Helm Values
The `values.yaml` file containing the configuration parameters for a chart. This file allows developers to customize the deployment (e.g., changing image tags, replica counts, or database endpoints) across different environments (Dev, QA, Prod) without modifying the underlying template structure.

##### 3. Helm Templates
The dynamic YAML blueprint manifests inside a chart. They leverage the Go template engine to ingest parameters directly from the Helm Values files, generating valid, real-time Kubernetes manifests upon evaluation.

##### 4. Helm Repository
A remote cloud storage location where packaged Helm Charts are published, indexed, and shared. Examples include community collections like Bitnami, open-source hubs like Artifact Hub, or private registries.

##### 5. Helm Client (CLI)
The command-line tool (`helm`) installed on a local administrator workstation or a CI/CD runner. It communicates locally with your machine configurations and sends final declarative commands directly to the targeted Kubernetes Cluster API server.

##### 6. Helm Release
A running instance of a Helm Chart deployed inside a specific Kubernetes cluster namespace. If you deploy the same `catalog` chart twice into a single cluster, you will generate two distinct, named Helm Releases.

##### 7. Helm Install / Uninstall
* **Install:** The operational command used to deploy a specific Helm chart into a cluster for the first time, generating an initial release tracking record.
* **Uninstall:** The command used to completely tear down a release instance, cleaning up all pods, services, and associated resources managed by that deployment hook.

##### 8. Helm Upgrade
The command executed to update an existing running release. Whether you modify application configuration parameters inside your values file or upgrade your container image versions, Helm tracks modifications sequentially by incrementing the release revision number.

##### 9. Helm Rollback
A critical fallback command that allows engineers to instantly revert a broken deployment to a previous, known-stable release revision number (e.g., reverting from Revision 3 back to Revision 2) if an upgrade encounters runtime failure.

##### 10. Helm Package
The final build step where a directory containing templates and config files is compressed into a standardized `.tgz` tarball archive, complete with semantic version tagging, making it ready for distribution to an OCI registry or chart repository.

---

#### The End-to-End Helm Workflow

The following section explains how traffic and packages move step-by-step through the cloud delivery pipeline:


##### Chart Creation & Build
The development loop begins on an engineer's workstation. The **Developer** builds localized configuration manifests for microservices (such as *catalog*, *cart*, *checkout*, *orders*, or the frontend *UI*). These distinct applications are packaged into individual **Retail Store Helm Charts**.

##### SHosting in Chart Repositories
Once packaged, the charts are uploaded (**Host**) to remote infrastructure locations to ensure durability and team access. These are split into two major architecture layouts:
* **Open-source Repositories:** Public indexing endpoints like *Artifacthub*, *Bitnami*, or vendor-specific portals.
* **OCI Registries (Standard):** Modern cloud-native registries including *Amazon ECR (Elastic Container Registry)*, *Azure ACR*, or *GCP Artifact Registry*. In our production layout, the retail store charts are pushed and stored directly inside Amazon ECR utilizing secure `oci://` URI patterns.

##### Admin Workspace Configuration
A **Kubernetes Administrator** or automated CI/CD engine interfaces with an administrative workstation. The workspace must have the **Helm CLI** binary installed along with proper `kubeconfig` network access keys to authenticate targeting permissions for the destination cluster.

##### Pulling the Remote Charts
When a deployment action is triggered, the **Helm CLI** runs an update command to securely connect to the authenticated **OCI Registries (AWS ECR)** or open repos. It syncs the remote indexes and downloads (**Pull Helm Charts**) the requested versions locally into temporary memory.

##### Cluster Deployment & Release Management
The operator issues an installation configuration command. The **Helm CLI** compiles the templates using the matching environment values file and sends them to the **Kubernetes Cluster**. 

This executes the final phase of the pipeline, creating running, tracked application releases matching your targeted architectural states:
* `catalog` $\rightarrow$ **Helm Release 1** / **Helm Release 2**
* `orders` $\rightarrow$ **Helm Release 1** / **Helm Release 2**

This lifecycle guarantees consistent management stretching from initial creation, through registry hosting, down to cluster updates and rollback protections.



---

## Helm-Custom-Values

- Helm Values Precedence
    ```bash
    ▲  [ HIGH PRIORITY - Overwrites everything below ]
    │
    │  6. --set-file path/to/file.txt
    │     (Injects complete contents of a file as a string)
    │
    │  5. --set-string key=value
    │     (Forces value to be parsed strictly as a string type)
    │
    │  4. --set key=value
    │     (Command-line overrides passed directly in the terminal)
    │
    │  3. -f values-env.yaml / --values values-env.yaml
    │     (Custom environment files; processed Left-to-Right if multiple)
    │
    │  2. Parent Chart's values.yaml
    │     (The default values file at the root of the main chart)
    │
    │  1. Subchart's (Dependency) values.yaml
    │     (The default configuration of a child dependency chart)
    │
    ▼  [ LOW PRIORITY - Overwritten by everything above ]

    ```

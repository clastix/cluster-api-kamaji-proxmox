# Cluster API Kamaji Proxmox Virtual Environment

This Helm chart deploys a Kubernetes cluster on Proxmox Virtual Environment using [Cluster API](https://cluster-api.sigs.k8s.io/) with [Kamaji](https://kamaji.clastix.io/) as the Control Plane Provider.

The Proxmox Cluster API implementation is initiated and maintained by [IONOS Cloud](https://github.com/ionos-cloud).


## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Key Features](#key-features)
  - [Automatic Rolling Updates](#automatic-rolling-updates)
  - [Cluster Autoscaler Integration](#cluster-autoscaler-integration)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Secret Management](#secret-management)
- [Usage](#usage)
  - [Creating a cluster](#creating-a-cluster)
  - [Upgrading a cluster](#upgrading-a-cluster)
  - [Scaling a cluster](#scaling-a-cluster)
  - [Deleting a cluster](#deleting-a-cluster)
- [Configuration](#configuration)
- [Maintainers](#maintainers)
- [Source Code](#source-code)
- [License](#license)

## Architecture Overview

The chart implements a **Hosted Control Plane Architecture** where the Kubernetes control plane of the workload clusters run in the Management Cluster and are managed by the Kamaji Operator. This architecture allows for a more efficient use of resources and simplifies the management of the control plane components.

This approach also provides security benefits by isolating Proxmox VE credentials from tenant users while maintaining full Cluster API integration.


## Key Features

### Automatic Rolling Updates

The chart supports seamless rolling updates of the workload clusters when the configuration changes. This works through Cluster API's machine lifecycle management for:

- Physical machine parameter changes, e.g. CPU, memory, disk
- Kubernetes version upgrades
- proxmox template changes
- `cloud-init` configuration updates

The implementation uses hash-suffixed templates, `ProxmoxMachineTemplate` and `KubeadmConfigTemplate` that:
1. Generate a new template with updated configuration and unique name on `helm upgrade`
2. Update references in `MachineDeployment` to the new template
3. Trigger Cluster API's built-in rolling update process

#### Rolling Update Workflow

1. Update `values.yaml` with new configuration
2. Run: `helm upgrade my-cluster ./cluster-api-kamaji-proxmox`
3. Cluster API automatically replaces nodes using the new configuration

### Cluster Autoscaler Integration

The chart includes support for enabling the Cluster Autoscaler for each node pool. This feature allows you to mark node pool machines to be autoscaled. However, you still need to install the Cluster Autoscaler separately.

The Cluster Autoscaler runs in the management cluster, following the hosted control plane model, and manages the scaling of the workload cluster. To enable autoscaling for a node pool, set the `autoscaling.enabled` field to `true` in your `values.yaml` file:

```yaml
nodePools:
  - name: default
    replicas: 3
    autoscaling:
      enabled: true
      minSize: 2
      maxSize: 6
      labels:
        autoscaling: "enabled"
```

This configuration marks the node pool for autoscaling. The Cluster Autoscaler will use these settings to scale the node pool within the specified limits.

You need to install the Cluster Autoscaler in the management cluster. Here is an example using Helm:

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update
helm upgrade --install ${CLUSTER_NAME}-autoscaler autoscaler/cluster-autoscaler \
    --set cloudProvider=clusterapi \
    --set autodiscovery.namespace=default \
    --set "autoDiscovery.labels[0].autoscaling=enabled" \
    --set clusterAPIKubeconfigSecret=${CLUSTER_NAME}-kubeconfig \
    --set clusterAPIMode=kubeconfig-incluster
```

This command installs the Cluster Autoscaler and configures it to manage the workload cluster from the management cluster.

## Prerequisites

- Management Cluster with Kubernetes 1.28+
- Kamaji installed and configured on the Management Cluster
- Cluster API installed and configured on the Management Cluster with the [Proxmox Provider](https://github.com/ionos-cloud/cluster-api-provider-proxmox)
- IPAM provider (optional)
- Helm 3.x
- Access to a Proxmox VE cluster with the necessary permissions to create and manage VMs

## Installation

```bash
# Add repository (if published)
helm repo add clastix https://clastix.github.io/charts
helm repo update

# Install with custom values
helm install my-cluster clastix/capi-kamaji-proxmox -f my-values.yaml
```

## Secret Management

The chart requires a proxmox credential secret.

It is strongly recommended to use dedicated Proxmox VE user + API token:

```bash
export PROXMOX_URL: "https://pve.example:8006"  # The Proxmox VE host
export PROXMOX_TOKEN: "clastix@pam!capi"        # The Proxmox VE TokenID for authentication
export PROXMOX_SECRET: "REDACTED"               # The secret associated with the TokenID
```

Then you create the secret manually:

```bash
# Create the proxmox secret for Cluster API
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: sample-proxmox-secret
  labels:
    cluster.x-k8s.io/cluster-name: "sample"
stringData:
  url: "${PROXMOX_URL}"
  token: "${PROXMOX_TOKEN}"
  secret: "${PROXMOX_SECRET}"
type: Opaque

EOF
```

and reference it in your `values.yaml`:

```yaml
# Using existing secrets
proxmox:
  secret:
    name: sample-proxmox-secret
    # -- omitting namespace will use the release namespace
    namespace: default
```

## Usage

### Creating a cluster

```bash
# Deploy using the chart
helm install my-cluster clastix/capi-kamaji-proxmox -f values.yaml

# Check status
kubectl get cluster,machines

# Get kubeconfig
clusterctl get kubeconfig my-cluster > my-cluster.kubeconfig
```

### Upgrading a cluster

```bash
# Update values.yaml
cluster:
  version: "v1.32.2"
nodePools:
  - name: default
    templateId: 100

# Apply upgrade
helm upgrade my-cluster clastix/capi-kamaji-proxmox -f values.yaml

# Watch the rolling update
kubectl get machines -w
```

### Scaling a cluster

```bash
# Update values.yaml
nodePools:
  - name: default
    replicas: 5

# Apply scaling
helm upgrade my-cluster clastix/capi-kamaji-proxmox -f values.yaml

# Watch the scaling
kubectl get machines -w
```

### Deleting a cluster

```bash
# Delete the cluster
helm uninstall my-cluster
```

## Configuration

See the [values](charts/capi-kamaji-proxmox/README.md) you can override.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Clastix Labs | <authors@clastix.labs> |  |

## Source Code

* <https://github.com/clastix/cluster-api-kamaji-proxmox>

## License

This project is licensed under the Apache2 License. See the LICENSE file for more details.

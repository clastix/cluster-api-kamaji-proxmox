# capi-kamaji-proxmox

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.31.4](https://img.shields.io/badge/AppVersion-1.31.4-informational?style=flat-square)

A Helm chart for deploying a Kamaji Tenant Cluster on Proxmox VE using Cluster API and Kamaji.

**Homepage:** <https://kamaji.clastix.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Clastix Labs | <authors@clastix.labs> |  |

## Source Code

* <https://github.com/clastix/cluster-api-kamaji-proxmox>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cluster.allowedNodes | list | `["labs"]` | Proxmox VE nodes used for VM deployments |
| cluster.clusterNetwork.apiServerPort | int | `6443` | API Server port |
| cluster.clusterNetwork.pods.cidrBlocks | list | `["10.93.0.0/16"]` | CIDR range for pods |
| cluster.clusterNetwork.serviceDomain | string | `"cluster.local"` | Service Domain for cluster DNS |
| cluster.clusterNetwork.services.cidrBlocks | list | `["10.96.0.0/16"]` | CIDR range for services |
| cluster.controlPlane.addons | object | `{"coreDNS":{},"konnectivity":{},"kubeProxy":{}}` | Configure addons for the control plane |
| cluster.controlPlane.addons.coreDNS | object | `{}` | CoreDNS addon configuration |
| cluster.controlPlane.addons.konnectivity | object | `{}` | Konnectivity addon configuration |
| cluster.controlPlane.addons.kubeProxy | object | `{}` | Kube-proxy addon configuration |
| cluster.controlPlane.dataStoreName | string | `"default"` | KamajiControlPlane dataStoreName |
| cluster.controlPlane.deployment | object | `{"additionalMetadata":{"annotations":{},"labels":{}},"affinity":{},"nodeSelector":{"kubernetes.io/os":"linux"},"podAdditionalMetadata":{"annotations":{},"labels":{}},"tolerations":[],"topologySpreadConstraints":[]}` | Configure how KamajiControlPlane deployment should be done |
| cluster.controlPlane.deployment.additionalMetadata | object | `{"annotations":{},"labels":{}}` | Additional metadata as labels and annotations |
| cluster.controlPlane.deployment.affinity | object | `{}` | Affinity scheduling rules |
| cluster.controlPlane.deployment.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | NodeSelector for scheduling |
| cluster.controlPlane.deployment.podAdditionalMetadata | object | `{"annotations":{},"labels":{}}` | Pods Additional metadata as labels and annotations |
| cluster.controlPlane.deployment.tolerations | list | `[]` | Tolerations for scheduling |
| cluster.controlPlane.deployment.topologySpreadConstraints | list | `[]` | TopologySpreadConstraints for scheduling |
| cluster.controlPlane.kubelet.cgroupfs | string | `"systemd"` | kubelet cgroupfs configuration |
| cluster.controlPlane.kubelet.preferredAddressTypes | list | `["InternalIP","ExternalIP","Hostname"]` | kubelet preferredAddressTypes order |
| cluster.controlPlane.labels | object | `{"cni":"calico"}` | Labels to add to the control plane |
| cluster.controlPlane.network.certSANs | list | `[]` | List of additional Subject Alternative Names to use for the API Server serving certificate |
| cluster.controlPlane.network.serviceLabels | object | `{}` | Labels to use for the control plane service |
| cluster.controlPlane.network.serviceType | string | `"LoadBalancer"` | Type of service used to expose the Kubernetes API server |
| cluster.controlPlane.replicas | int | `2` | Number of control plane replicas |
| cluster.controlPlane.version | string | `"v1.31.4"` | Kubernetes version |
| cluster.credentialsRef.name | string | `"sample-proxmox-secret"` | Proxmox VE credentials secret name |
| cluster.credentialsRef.namespace | string | `"default"` | Proxmox VE credentials secret namespace |
| cluster.dnsServers | list | `["8.8.8.8"]` | List of nameservers used by the machines |
| cluster.ipv4Config | object | `{"addresses":["192.168.100.10"],"gateway":"192.168.100.1","prefix":24}` | IPv4Config contains information about address pool |
| cluster.ipv4Config.addresses | list | `["192.168.100.10"]` | Proxmox VE machines address pool |
| cluster.ipv4Config.gateway | string | `"192.168.100.1"` | Proxmox VE machines gateway |
| cluster.ipv4Config.prefix | int | `24` | Proxmox VE machines prefix |
| cluster.metrics.enabled | bool | `false` | Enable metrics collection. ServiceMonitor custom resource definition must be installed on the Management cluster. |
| cluster.metrics.serviceAccount | object | `{"name":"kube-prometheus-stack-prometheus","namespace":"monitoring-system"}` | ServiceAccount for scraping metrics |
| cluster.metrics.serviceAccount.name | string | `"kube-prometheus-stack-prometheus"` | ServiceAccount name used for scraping metrics |
| cluster.metrics.serviceAccount.namespace | string | `"monitoring-system"` | ServiceAccount namespace |
| cluster.name | string | `""` | Cluster name. If unset, the release name will be used |
| ipamProvider.enabled | bool | `true` | Enable the IPAMProvider usage |
| ipamProvider.gateway | string | `"192.168.100.1"` | IPAMProvider gateway |
| ipamProvider.prefix | string | `"24"` | IPAMProvider prefix |
| ipamProvider.ranges | list | `["192.168.100.10-192.168.100.250"]` | IPAMProvider ranges |
| nodePools[0].additionalCloudInitFiles | string | `"#cloud-config\ntimezone: Europe/Rome\n"` | Additional cloud-init files to pass to the machines |
| nodePools[0].allowedNodes | list | `["labs"]` | Proxmox VE nodes used for VM deployments |
| nodePools[0].autoscaling.enabled | bool | `false` | Enable autoscaling |
| nodePools[0].autoscaling.labels.autoscaling | string | `"enabled"` | Labels to use for autoscaling: make sure to use the same labels on the autoscaler configuration |
| nodePools[0].autoscaling.maxSize | string | `"6"` | Maximum number of instances in the pool |
| nodePools[0].autoscaling.minSize | string | `"1"` | Minimum number of instances in the pool |
| nodePools[0].disks | object | `{"bootVolume":{"disk":"scsi0","sizeGb":25}}` | Proxmox VE disk configuration |
| nodePools[0].disks.bootVolume | object | `{"disk":"scsi0","sizeGb":25}` | Proxmox VE disk for the boot volume |
| nodePools[0].disks.bootVolume.disk | string | `"scsi0"` | Proxmox VE disk bus type |
| nodePools[0].disks.bootVolume.sizeGb | int | `25` | Proxmox VE disk size in GB. The disk size must be greater than the template disk size |
| nodePools[0].format | string | `"qcow2"` | Proxmox VE disk format |
| nodePools[0].memoryMiB | int | `8192` | Memory to allocate to worker VMs |
| nodePools[0].name | string | `"default"` |  |
| nodePools[0].network | object | `{"addressesFromPools":{"enabled":true},"bridge":"vmbr0","dnsServers":["8.8.8.8"],"model":"virtio"}` | Proxmox VE default network for VMs |
| nodePools[0].network.addressesFromPools | object | `{"enabled":true}` | Use an IPAMProvider pool to reserve IPs |
| nodePools[0].network.addressesFromPools.enabled | bool | `true` | Enable the IPAMProvider usage |
| nodePools[0].network.bridge | string | `"vmbr0"` | Proxmox VE network bridge to use |
| nodePools[0].network.dnsServers | list | `["8.8.8.8"]` | Proxmox VE network interface dns servers. Overrides the setting in ProxmoxCluster |
| nodePools[0].network.model | string | `"virtio"` | Proxmox VE network interface model to use |
| nodePools[0].numCores | int | `2` | Number of cores to allocate to worker VMs |
| nodePools[0].numSockets | int | `2` | Number of sockets to allocate to worker VMs |
| nodePools[0].pool | string | `""` | Proxmox VE resource pool to use |
| nodePools[0].replicas | int | `1` | Number of worker VMs instances |
| nodePools[0].sourceNode | string | `"pve"` | Proxmox VE node that hosts the VM template to be used to provision VMs |
| nodePools[0].storage | string | `"local"` | Proxmox VE storage name for full clone |
| nodePools[0].templateId | int | `100` | Proxmox VE template ID to clone (alternatively, use TemplateSelector) |
| nodePools[0].templateSelector | object | `{"matchTags":["ubuntu-nobe-kube-1.31.4"]}` | Proxmox VE template selector (alternatively, use templateId) |
| nodePools[0].templateSelector.matchTags | list | `["ubuntu-nobe-kube-1.31.4"]` | Proxmox VE template match tags |
| nodePools[0].users | list | `[{"lockPassword":true,"name":"ubuntu","shell":"/bin/bash","sshAuthorizedKeys":[],"sudo":"ALL=(ALL) NOPASSWD:ALL"}]` | users to create on machines |
| nodePools[0].users[0].lockPassword | bool | `true` | Lock login password |
| nodePools[0].users[0].shell | string | `"/bin/bash"` | SSH shell to use |
| nodePools[0].users[0].sshAuthorizedKeys | list | `[]` | SSH public key to add |
| nodePools[0].users[0].sudo | string | `"ALL=(ALL) NOPASSWD:ALL"` | sudoers configuration |
| proxmox.secret | object | `{"name":"proxmox-secret","namespace":""}` | Proxmox VE credentials |
| proxmox.secret.name | string | `"proxmox-secret"` | The name of an existing credentials secret for Proxmox VE. |
| proxmox.secret.namespace | string | `""` | The namespace of the existing credentials secret for Proxmox VE. When null or empty the release namespace will be used. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

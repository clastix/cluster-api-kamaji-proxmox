{{- define "ProxmoxMachineTemplateSpec" -}}
allowedNodes:
{{- range .nodePool.allowedNodes }}
- {{ . }}
{{- end }}
disks:
  bootVolume:
    disk: {{ .nodePool.disks.bootVolume.disk }}
    sizeGb: {{ .nodePool.disks.bootVolume.sizeGb }}
storage: {{ .nodePool.storage }}
format: {{ .nodePool.format }}
full: true
network:
  default:
    {{- if and .nodePool.network.addressesFromPools .nodePool.network.addressesFromPools.enabled }}
    ipv4PoolRef:
      apiGroup: ipam.cluster.x-k8s.io
      kind: InClusterIPPool
      name: {{ include "cluster-api-kamaji-proxmox.cluster-name" .Global }}-ipam-ip-pool
    {{- end }}
    dnsServers:
    {{- range .nodePool.network.dnsServers }}
    - {{ . }}
    {{- end }}
    bridge: {{ .nodePool.network.bridge }}
    model: {{ .nodePool.network.model }}
memoryMiB: {{ .nodePool.memoryMiB }}
numCores: {{ .nodePool.numCores }}
numSockets: {{ .nodePool.numSockets }}
sourceNode: {{ .nodePool.sourceNode }}
pool: {{ .nodePool.pool }}
{{- if .nodePool.templateId }}
templateID: {{ .nodePool.templateId }}
{{- else }}
templateSelector:
  matchTags:
  {{- range .nodePool.templateSelector.matchTags }}
  - {{ . }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Calculates a SHA256 hash of the ProxmoxMachineTemplate content.
*/}}

{{- define "ProxmoxMachineTemplateHash" -}}
{{- $templateContent := include "ProxmoxMachineTemplateSpec" . -}}
{{- $templateContent | sha256sum | trunc 8 -}}
{{- end -}}
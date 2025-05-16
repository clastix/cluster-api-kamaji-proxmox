{{- define "kubeadmConfigTemplateSpec" -}}
joinConfiguration:
  nodeRegistration:
    name: {{`'{{ local_hostname }}'`}}
    criSocket: /var/run/containerd/containerd.sock
    kubeletExtraArgs:
      provider-id: proxmox://{{`'{{ ds.meta_data.instance_id }}'`}}
      {{- if and .nodePool (hasKey .nodePool "labels") }}
      node-labels: {{ .nodePool.labels }}
      {{- end }}
      {{- if and .nodePool (hasKey .nodePool "taints") }}
      register-with-taints: {{ .nodePool.taints}}
      {{- end }}
{{- if .nodePool.additionalCloudInitFiles }}
files:
- path: "/etc/cloud/cloud.cfg.d/99-custom.cfg"
  content: {{ .nodePool.additionalCloudInitFiles | quote }}
  owner: "root:root"
  permissions: "0644"
{{- end }}
{{- if .nodePool.users }}
users:
{{- range .nodePool.users }}
  - {{- toYaml . | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculates a SHA256 hash of the kubeadmConfigTemplate content.
*/}}

{{- define "kubeadmConfigTemplateHash" -}}
{{- $templateContent := include "kubeadmConfigTemplateSpec" . -}}
{{- $templateContent | sha256sum | trunc 8 -}}
{{- end -}}
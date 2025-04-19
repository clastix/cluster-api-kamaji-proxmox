{{/* release name */}}
{{- define "cluster-api-kamaji-proxmox.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* cluster name */}}
{{- define "cluster-api-kamaji-proxmox.cluster-name" -}}
{{- default .Release.Name .Values.cluster.name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/* Proxmox VE secret name used by ClusterAPI */}}
{{- define "cluster-api-kamaji-proxmox.proxmox-secret-name" -}}
{{- if .Values.proxmox.secret.create -}}
{{- printf "%s-proxmox-secret" (include "cluster-api-kamaji-proxmox.cluster-name" .) -}}
{{- else -}}
{{- .Values.proxmox.secret.name | default "proxmox-secret" -}}
{{- end -}}
{{- end -}}


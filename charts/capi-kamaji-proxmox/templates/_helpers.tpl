{{/* release name */}}
{{- define "cluster-api-kamaji-proxmox.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* cluster name */}}
{{- define "cluster-api-kamaji-proxmox.cluster-name" -}}
{{- default .Release.Name .Values.cluster.name | trunc 63 | trimSuffix "-" }}
{{- end -}}


{{/*
Expand the name of the chart.
*/}}
{{- define "yolo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "yolo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "yolo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "yolo.labels" -}}
helm.sh/chart: {{ include "yolo.chart" . }}
{{ include "yolo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "yolo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "yolo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "yolo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "yolo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the proper image name
*/}}
{{- define "yolo.image" -}}
{{- if .Values.global.repoPrefix }}
    {{- printf "%s/%s:%s" .Values.global.repoPrefix .Values.image.repository .Values.image.tag -}}
{{- else }}
    {{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end }}
{{- end }}

{{/*
Get the proper url
*/}}
{{- define "yolo.url" -}}
{{- $protocol := "http" }}
{{- if .Values.https.enabled -}}
{{- $protocol = "https" }}
{{- end }}
{{- printf "%s://%s-yolo.%s" $protocol .Release.Name .Release.Namespace }}
{{- end }}

{{/*
Get the proper testing port
*/}}
{{- define "yolo.testport" -}}
{{- if .Values.https.enabled -}}
port: {{ .Values.service.https.port }}
scheme: HTTPS
{{- else -}}
port: {{ .Values.service.http.port }}
{{- end -}}
{{- end -}}

{{- define "dbg.var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{/* Check topologySpreadConstraints supports minDomains */}}
{{/* minDomains was added in Kubernetes 1.28 */}}
{{- define "tps.supportsMinDomains" -}}
  {{- semverCompare ">= 1.28-0" .Capabilities.KubeVersion.Version -}}
{{- end -}}

{{/* Check if any node has gpu resource */}}
{{- define "chk_gpu" -}}
{{- $ret_gpu := false -}}
{{- range $index, $anode := (lookup "v1" "Node" "" "").items -}}
  {{/*-  template "dbg.var_dump" $anode.status.capacity  -*/}}
  {{- if (hasKey $anode.status.capacity "nvidia.com/gpu") }}
  {{- $ret_gpu = true -}}
  {{- end -}}
{{- end -}}
{{- $ret_gpu -}}
{{- end -}}


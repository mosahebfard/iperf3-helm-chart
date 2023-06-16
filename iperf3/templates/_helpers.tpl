{{/*
Expand the name of the chart.
*/}}
{{- define "iperf3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iperf3.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iperf3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iperf3.labels" -}}
helm.sh/chart: {{ include "iperf3.chart" . }}
{{ include "iperf3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
tags.datadoghq.com/env: {{ .Values.env | default "unknown" }}
tags.datadoghq.com/service: {{ include "iperf3.fullname" . }}
tags.datadoghq.com/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iperf3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iperf3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iperf3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iperf3.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for the object
*/}}
{{- define "apiVersion" -}}
{{- default "v1" .Values.apiVersion -}}
{{- end -}}

{{/*
Create the correct name for the namespace
If global namespace let's use it else fullname will be used .
*/}}
{{- define "iperf3.namespace" -}}
	{{- if .Values.global }}
		{{- if .Values.global.namespace }}
			{{- .Values.global.namespace | trunc 63 | trimSuffix "-" }}
		{{- else }}
			{{- include "iperf3.fullname" . }}
		{{- end }}
	{{- else }}
		{{- include "iperf3.fullname" . }}
	{{- end }}
{{- end }}

{{/*
Return available autoscaling version
*/}}
{{- define "autoscalingVersion" -}}
	{{- if .Capabilities.APIVersions.Has "autoscaling/v2" -}}
		autoscaling/v2
	{{- else if .Capabilities.APIVersions.Has "autoscaling/v2beta2" -}}
		autoscaling/v2beta2
	{{- else if .Capabilities.APIVersions.Has "autoscaling/v2beta1" -}}
		autoscaling/v2beta1
	{{- end -}}
{{- end -}}

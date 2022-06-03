{{/*
Expand the name of the chart.
*/}}
{{- define "release.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "release.fullname" -}}
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
{{- define "release.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "release.labels" -}}
helm.sh/chart: {{ include "release.chart" . }}
{{ include "release.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.application.gcpLabels.environment }}
organisation: {{ .Values.application.gcpLabels.organisation }}
project_manager: {{ .Values.application.gcpLabels.projectManager }}
project_name: {{ .Values.application.gcpLabels.projectName }}
{{- end }}

{{/*
Drupal labels
*/}}
{{- define "drupal.labels" -}}
component: drupal
{{- end }}

{{/*
PWA labels
*/}}
{{- define "pwa.labels" -}}
component: pwa
{{- end }}

{{/*
Cron labels
*/}}
{{- define "cron.labels" -}}
component: job
{{- end }}

{{/*
Selector labels
*/}}
{{- define "release.selectorLabels" -}}
app: website
version: {{ .Values.application.deploymentVersion | quote }}
app.kubernetes.io/name: {{ include "release.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
release: {{ .Release.Name | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "drupal.selectorLabels" -}}
tier: backend
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pwa.selectorLabels" -}}
tier: frontend
{{- end }}

{{/*
Selector cron labels
*/}}
{{- define "cron.selectorLabels" -}}
tier: job
{{- end }}

{{/*
Create the volumes definition
*/}}
{{- define "volume.definition" -}}
- name: {{ .spec.name }}-volume
{{- if ne .spec.mountType "file" }}
  persistentVolumeClaim:
    claimName: {{ .resourcePrefix}}-{{ .componentName }}-{{ .spec.name }}-pvc
    readOnly: {{ .spec.readOnly | default false }}
{{- else }}
{{- if eq .spec.volumeFileType "configMap" }}
  configMap:
    name: {{ .resourcePrefix}}-{{ .componentName }}-{{ .spec.name }}-configmap
{{- end }}
{{- if eq .spec.volumeFileType "secret" }}
  secret:
    secretName: {{ .resourcePrefix}}-{{ .componentName }}-{{ .spec.name }}-secret
{{- end }}
{{- end }}
{{- end -}}

# Return list of certificates
{{- define "listOfCertificates" -}}
{{- range . }}{{ (print .gcpCertificateName) }},{{- end }}
{{- end }}
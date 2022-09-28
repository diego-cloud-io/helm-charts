{{/*
Uniqueness hash for changes to environment configuration.
*/}}
{{- define "config.hash" -}}
{{ printf "%s-%s" (include "webservice.fullname" .) .Values.env | toJson | sha256sum }}
{{- end }}

{{/*
Managed secret/configmap name
*/}}
{{- define "configs.name" -}}
{{- include "webservice.fullname" . | trunc 53 | trimSuffix "-" }}-{{ include "config.hash" . | trunc 10 }}
{{- end }}

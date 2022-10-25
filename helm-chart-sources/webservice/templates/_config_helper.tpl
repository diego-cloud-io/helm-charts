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

{{/*
Environment configuration helper.

This is a helper to be injected into podspec, providing a complete set of environments,
based on the 'env' values. It will reference the secret or configmap as needed.

Should be injected once per pod spec in 'env'. Should be indented. Output e.g.:

```
- name: MY_ENV_VAR
  valueFrom:
    configMapKeyRef:
      key: something-internal
      name: the-configmap-name
      optional: false
- name: MY_SECRET_ENV_VAR
  valueFrom:
    secretKeyRef:
      key: something-else-internal
      name: the-secret-name
      optional: false
```
*/}}
{{- define "configs.env" -}}
{{- $top := . -}}
{{- range $key , $val := .Values.env -}}
{{- if (ne $val.value nil) }}
- name: {{ $key }}
  valueFrom:
    configMapKeyRef:
      key: {{ $key }}
      name: {{ include "configs.name" $top }}
      optional: false
{{- end }}
{{- if (ne $val.secretPath nil) }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      key: {{ $key }}
      name: {{ include "configs.name" $top }}
      optional: false
{{- end }}
{{- end }}
{{- end }}
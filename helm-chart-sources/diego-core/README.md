# diego-core

Provides Diego's core components:

 * diego-application-controller
 * diego-api

## Example ArgoCD application

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: diego-api
spec:
  project: default
  syncPolicy:
    automated: null
    syncOptions:
      - CreateNamespace=true
  destination:
    server: https://kubernetes.default.svc
    namespace: diego
  source:
    chart: diego-core
    repoURL: https://diego-cloud-io.github.io/helm-charts/
    targetRevision: 0.1.0
    helm:
      releaseName: diego
      values: |
        diego_application_controller_crds:
          enabled: true # this is once per cluster
        diego_api:
          ingress:
            enabled: true
            className: alb
            annotations: 
              alb.ingress.kubernetes.io/scheme: internet-facing
              alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
              alb.ingress.kubernetes.io/healthcheck-path: /health
            hosts:
              - host: diego-api.core.example.com
                paths:
                  - path: /
                    pathType: Prefix
            tls: 
              - hosts:
                - diego-api.core.example.com
          env:
            config:
              ARGOCD_API: https://argocd.core.example.com
              ARGOCD_USERNAME: admin
              ARGOCD_PASSWORD: ... omitted
              AUTH0_DOMAIN: https://diegocloud.eu.auth0.com/
              AUTH0_AUDIENCE: https://diego-api.core.dexample.com
```
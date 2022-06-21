# diego-core

Provides Diego's core components:

 * diego-application-controller
 * diego-api
## Dependencies

A secret named "github-app" will be required in the same namespace.

It should have keys:

 * app_id
 * installation_id
 * app.pem - complete PEM file


A separate secret named "diego-api" will be required in the same namespace.

It should have keys:

 * ARGOCD_API - e.g. https://argocd.core.example.com
 * ARGOCD_USERNAME - e.g. admin
 * ARGOCD_PASSWORD - corresponding to username
 * AUTH0_DOMAIN - e.g. 
 * AUTH0_AUDIENCE - e.g. https://diego-api.core.example.com
 * AUTH0_CLIENT_ID - e.g. 
 * AUTH0_CLIENT_SECRET - e.g. 
 * GITHUB_REPO_OWNER - e.g. my-github-org


## Testing

Following are helpers for local testing and development.

Quick install check:

```
(kubectl delete namespace diego || true) \
&& kubectl create namespace diego \
&& helm template --no-hooks --namespace diego --set diego_application_controller_crds.enabled=true --set diegoapi.host=diego-api.core.example.com \
   diego . | kubectl apply -n diego -f -
```

Global resources cleanup:

```
kubectl delete crd applications.management.diegocloud.io \
&& kubectl get clusterrole | grep diego | awk '{print $1}' | xargs kubectl delete clusterrole \
&& kubectl get clusterrolebinding |grep diego | awk '{print $1}' | xargs kubectl delete clusterrolebinding
```

Create example secrets:

```
cat <<EOF | kubectl apply -n diego  -f -
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: github-app
stringData:
  app_id: "12345"
  installation_id: "11111111"
  app.pem: |
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAxHwFj/vWS67sIHy1l9NH/O5M0icIqX4TNe56Nnolq5AAnhSp
    o6Zd9/tzXhQ8e0hkGQxBMXPLs6Z7Ts0vL36+IprJUlJ6ZVnBaSZRuu1Ju+25Ec53
    GJUtk3+tCw9jNOUvotf+rnDg1NJfOtHQBKu1zKz1GoHoXCK2K7MBkjl8UID2ZNns
    2bMdp4x/xxyr4oM+qYba8s2c/RwvEi0vQESdFJ9dKV5hWiUea8hV5i2YaNdIsSO0
    GxwyxHCQCan92SGJpX/22WQhtUUjwnwha9t6dWYHY00DtYgnnblzZO9+F+xCdnwk
    6T3KwV8qo6Io8y4gMQPgRVRmBGZ/h2FpPm+KSwIDAQABAoIBAQCcXgcfO1CkEqWg
    hR8PoPmddRh19tKR8N/g/9ULHdJ04rlbFR6cOn52KAr8SCaKBmaC+Jm5fWoTot5n
    LCvtJHS0nXKyrSjzF6cww2ov1T/k659paGKnkbEfvXA9aRWOtwZeFn983CBRvspC
    yU8/KFgad1roqZH+ITHRPTh24oDonxQglvmsgkm9CSPCtV7zDbrGrzqlUaYA2jo8
    NwxDjSIU9Z0gMNfayK8bBcxoHR6iwEhQC805XFSRk89e5GGogW+bz8OAK5x3u2yS
    g/Ae5d/hSWLNnAY5fei0HJBDggWe1YAecvoAvVyhiiyjUInVr+CB0dWmH1ISFopO
    EApP4dPBAoGBAOqnsBbXMEQvyeThxwbepw9N8Bxln9DYcrBefs69VIlyifd+Fv71
    rpPskEyoD7XuzzwMHJogf4GbeYkby519jSsEA57MhZlFbicbI5CemXGYARoQ8h2G
    zOikFnw4YjZe1WpRm85aXiEda7EZ0NZT8Rqb/slm+sjY0PrrvFDtkvNJAoGBANZb
    eNRnA8Vi2ymcoGF+Y4xg+mqnvc/Sb63UZ1xRGfJdJvV0jQYY/VWvPN5kpk3BFw3N
    KGnDb0A4I8RWynIfIfwftkQQVEBxw6+QPCSlpcdBDBXenzRf/bG9++wy182UUfc0
    UAfFR+3QIdGMMAJPeqPqzm66b5AqgE/epGfuAbzzAoGAMZyCflHAwqnX5axWh/1L
    FNFFkrtprp4UoXVZGhytYuH0iX7/HaiT4HKDj7F4oN58shVddrioPJ7Cc1qNEh8Z
    WZ7fpRNYq68iOuJiApGFn56jnP84MUXuzMDkgB7rpNMoC/J1Hou8mwO9YRQ0MxxM
    PXP9ylcbbptok6SDjBiumQECgYBRm/uxqhKmeI+GFSp+U7ckv9s29evvDmgUXzSG
    0h21xz9I3fm+4463q4LaDKnAGo5jY8NKGOznHziGzKBAuJegvJYQ7cKV0no1Ag3T
    yfkGlj46qUolj5IvtGwQLf85NonKOvFpM/PBl6b4d43jo0zG0WOMhpBo67V0MwiW
    xOeGfwKBgA15gBL6pFfioBcyuATZS1a6GNw30L6RLc5CEBPgvGM2qGw+Y9SAyoSh
    5XalmdEKQ0mTdi7fVP5eWbXkpa0e43GEjys10YisgIQelTkwr0xqboHrx9YH7Shz
    opSdh2OPJ0fAcmVTmELvGEearNo9BoUQy8xYFxJY7rIxXY0d/LJH
    -----END RSA PRIVATE KEY-----
EOF

cat <<EOF | kubectl apply -n diego -f -
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: diego-api
stringData:
  ARGOCD_API: https://argocd.core.example.com
  ARGOCD_USERNAME: admin
  ARGOCD_PASSWORD: password
  AUTH0_DOMAIN: https://diegocloud.eu.auth0.com/
  AUTH0_AUDIENCE: https://diego-api.core.example.com
  AUTH0_CLIENT_ID: "1234567890"
  AUTH0_CLIENT_SECRET: "1234567890"
  GITHUB_REPO_OWNER: diego-cloud-io
  GIN_MODE: release
EOF
```

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
        diegoapi:
          host: diego-api.core.example.com
```
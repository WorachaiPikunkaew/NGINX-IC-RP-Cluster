# NGINX-IC-RP-Cluster
```
helm show chart oci://ghcr.io/nginx/charts/nginx-ingress
helm install nginx-ingress oci://ghcr.io/nginx/charts/nginx-ingress --version <X.Y.Z> -n nginx-ingress --create-namespace -f helm-values.yaml
```

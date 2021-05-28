Prerequisites
* Kubernetes cluster deployed
* Installed Helm

1. Install GitLab
```
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@example.com
  --set global.edition=ce
```

Installation Notes:
During installation process, GitLab creates a pod "gitlab-shared-secrets" which
has to create secrets (password, hashes, etc.) for GitLab, but it is failing
because the pod cannot connect to Kubernetes ClusterIP, Kubernetes DNS and to Internet.

Steps to fix Internet connectivity:
```
kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD="can-reach=8.8.8.8"
```

Steps to fix Kubernetes ClusterIP and Kubernetes DNS:
Tried setting proxy settings to Docker,
Tried setting up Firewall to allow communication between both nodes.
BGP is still failing, but calicoctl is showing both nodes as UP and Established.

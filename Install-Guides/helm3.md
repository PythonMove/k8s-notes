## Install Helm using script
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 766 get_helm.sh
./get_helm.sh
```

## Connecting Helm to Minikube cluster
To let Helm access Minikube cluster, you have to start kubectl proxy.
```
kubectl proxy --port=8080 &
# Now verify it via simple helm command
helm ls
```

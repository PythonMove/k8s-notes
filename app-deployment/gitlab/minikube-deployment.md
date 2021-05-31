> **NOTE:** This deployment guide is fetched from [gitlab docs](https://docs.gitlab.com/charts/development/minikube/) and uses complete Gitlab deploy.

## Prerequisites
* Installed Minikube.
* Installed Helm3.

## Hardware requirements for minimal Gitlab deploy  
Some of Gitlab components disabled due to limited hardware allocations. There are also disabled components which do not work with Minikube.
* 3vCPUs
* 6GB RAM
* 96GB Storage

## Hardware requirements for complete Gitlab deploy
There are disabled only components which do not work with Minikube.
* 4vCPUs
* 10GB RAM
* 96GB Storage

1. Start minikube instance:  
```
minikube start --driver=kvm2 --cpus=4 --memory=10g --disk-size=96g --kubernetes-version=1.19.10 --container-runtime=docker --cni=calico
```

2. Add minikube addons:  
Ingress - (**Required**) - Enable ingress for proper functioning of Gitlab.
```
minikube addons enable ingress
```
Metrics-server - (**Optional**) - Enable only if you want to see K8s node/pod HW usage.
```
minikube addons enable metrics-server
```
Dashboard - (**Optional**) - Enable only if you want to use K8s GUI.
```
minikube addons enable dashboard
```

3. Deploy Gitlab helm charts:
```
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=$(minikube ip).nip.io \
  --set global.hosts.externalIP=$(minikube ip) \
  -f Values/gitlab-complete-values.yaml
```
> **NOTE:** You may have to wait a bit. On my machine (i7-8750H 6c/12t, 16GB RAM) it took about 15-20 minutes to create all pods. Consider setting higher timeout if you have older/less powerful machine.

4. Create a self-signed ca root certificate:  
```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/gitlab-selfsigned.key -out ~/gitlab-selfsigned.crt
```
Afterwards import the key to the google chrome certificates.
> **NOTE:** **This step on my machine did not create certificate which Google Chrome accepts**, but not having valid certificate does not prevent you from accessing the Gitlab page. You just have to ignore invalid certificate for now and can solve it later.

5. Go to the gitlab page via browser:  
```
https://gitlab.$(minikube ip).nip.io
```

6. Retrieve password for root user to login to gitlab:  
```
minikube kubectl -- get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
```

7. Login and you should be in.

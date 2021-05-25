> **NOTE:** This deployment guide is fetched from [gitlab docs](https://docs.gitlab.com/charts/development/minikube/).

1. Start minikube instance:  
```
minikube start --driver=kvm2 --cpus=4 --memory=10g --disk-size=64g --kubernetes-version=1.19.9 --container-runtime=docker --cni=calico --dns-domain=k8s.local
```
> **NOTE:** You may have to wait a bit. On my machine (i7-8750H 6c/12t, 16GB RAM) it took about 15-20 minutes to create all pods.

2. Add minikube addons:  
```
minikube addons enable ingress
minikube addons enable dashboard
```

3. Create a self-signed ca root certificate (**NOT VERIFIED - GOOGLE CHROME DID NOT ACCEPT .CRT FILE**):  
```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/gitlab-selfsigned.key -out ~/gitlab-selfsigned.crt
```
Afterwards import the key to the google chrome certificates.

4. Go to the gitlab page via browser:  
```
https://gitlab.$(minikube ip).nip.io
```

5. Ignore invalid certificate or add your self-signed ca root certificate from step 3.

6. Retrieve password for root user to login to gitlab:  
```
minikube kubectl -- get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
```

7. Login and you should be in.

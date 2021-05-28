> **CENTOS 8:** Following specifications and whole guide assumes you just installed fresh CentOS 8 Linux machines and made no changes to them.

> **GITLAB ARCHITECTURE:** Gitlab Architecture depends on available hardware resources. Following guide is written for minimal deployment with hardware resources described bellow
in specifications. For other architectures, check [Gitlab reference architectures](https://docs.gitlab.com/ee/administration/reference_architectures/).

> **TESTING:** This guide was so far tested only using gitlab-minimal-values.yaml.

## Master node minimal hardware specification
* OS - CentOS Linux release 8.2.2004 (Core)
* Kernel - 4.18.0-193.el8.x86_64
* CPU - 2vCPUs
* RAM - 4GB
* Storage - 64GB
* HOST IP - 192.168.122.135

## Worker node minimal hardware specification
* OS - CentOS Linux release 8.2.2004 (Core)
* Kernel - 4.18.0-193.el8.x86_64
* CPU - 3vCPUs
* RAM - 6GB
* Storage - 96GB
* HOST IP - 192.168.122.18

## Kubernetes cluster specification
* K8s version - 1.19.10
* Docker version - 1.19+
* 1xMaster node + 1xWorker node
* On-premise cluster using kubeadm.

## Gitlab specification
* Version - 13.12.
* Edition - Community.
* Architecture - [Up to 500 users](https://docs.gitlab.com/ee/administration/reference_architectures/1k_users.html).
---
# System update & Kubernetes installation
> **NOTE:** Skip this step if you are already up to date. If you do not have physical access to machines then reboot them at your own risk.

For this step, you can use [kubeadm install guide](Install-Guides/kubeadm.md). After you are done, continue with Kubeadm cluster deployment step.

# Kubeadm cluster deployment  
For this step, you can use [kubeadm cluster deployment guide](Cluster-Deployment/kubeadm.md). After you are done, continue with Helm3 installation step.  

# Helm3 installation
For this step, you can use [helm install guide](Install-Guides/helm3.md). After you are done, continue with Gitlab deployment step.

# Gitlab deployment
> **Gitlab Helm values reference:** You can find full helm chart values with explanations for gitlab [here](https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/values.yaml).  

1. Deploy nginx-ingress.  
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/baremetal/deploy.yaml
```
More on nginx-ingress baremetal deploy here:
  * [deployment options](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal)
  * [baremetal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#over-a-nodeport-service)
2. Edit [gitlab helm values](App-Deployment/Gitlab/Values/kubeadm-baremetal-values.yaml) according to the instructions inside the file.  
3. Deploy Gitlab using helm.
```
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  -f App-Deployment/Gitlab/Values/kubeadm-baremetal-values.yaml
```
4. Create Persistent volumes.  
On the node where Gitlab will be deployed, create folder structure for the Gitlab:
```
mkdir -p $HOME/gitlab/volumes/{redis,minio,postgresql,gitaly}
sudo chown -R 1001:1001 $HOME/gitlab
sudo chmod -R 777 $HOME/gitlab        # Yes, these permissions are too broad. You can experiment with them.
```
> **NOTE:** If you want to deploy more robust and functional Gitlab, it may ask for more persistent volumes. You can check all claims for volumes by:  
> kubectl get pvc  
> Afterwards, you can inspect these claims and create persistentVolume according to claims.  
> kubectl get pvc -oyaml  
> You can create these volumes and base it on the ones provided bellow. It is important to match metadata.labels.app, spec.capacity.storage, spec.accessModes and spec.volumeMode with the values requested in these volume claims.
>
#### Redis  
Create **gitlab-redis-pv.yaml** and paste following config:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: gitlab-redis-volume
  labels:
    app: redis
spec:
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 8Gi
  hostPath:
    path: "/home/student/gitlab/volumes/redis/"
```
Apply the volume:
```
kubectl apply -f gitlab-redis-pv.yaml
```
Wait for the PersistentVolumeClaim for Redis to be bound to the volume we just created. You can wait for the bound status by observing output of following command:
```
watch -n 10 -- kubectl get pvc
```
#### Minio  
Create **gitlab-minio-pv.yaml** and paste following config:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: gitlab-minio-volume
  labels:
    app: minio
spec:
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 10Gi
  hostPath:
    path: "/home/student/gitlab/volumes/minio/"
```
Apply the volume:
```
kubectl apply -f gitlab-redis-pv.yaml
```
Wait for the PersistentVolumeClaim for Minio to be bound to the volume we just created. You can wait for the bound status by observing output of following command:
```
watch -n 10 -- kubectl get pvc
```
#### PostgreSQL  
Create **gitlab-postgresql-pv.yaml** and paste following config:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: gitlab-postgresql-volume
  labels:
    app: postgresql
spec:
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 8Gi
  hostPath:
    path: "/home/student/gitlab/volumes/postgresql/"
```
Apply the volume:
```
kubectl apply -f gitlab-redis-pv.yaml
```
Wait for the PersistentVolumeClaim for PostgreSQL to be bound to the volume we just created. You can wait for the bound status by observing output of following command:
```
watch -n 10 -- kubectl get pvc
```
#### Gitaly  
Create **gitlab-gitaly-pv.yaml** and paste following config:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: gitlab-gitaly-volume
  labels:
    app: gitaly
spec:
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 50Gi
  hostPath:
    path: "/home/student/gitlab/volumes/gitaly/"
```
Apply the volume:
```
kubectl apply -f gitlab-redis-pv.yaml
```
Wait for the PersistentVolumeClaim for Gitaly to be bound to the volume we just created. You can wait for the bound status by observing output of following command:
```
watch -n 10 -- kubectl get pvc
```
5. Verify Gitlab status  
Check pods, all should be running or completed.
```
kubectl get pods -o wide
```
If they are not running, check **Troubleshooting** step.

# Troubleshooting
**Error: Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io":**  
If this happens, most of the times simple gitlab reinstall helped.
```
helm uninstall gitlab; sleep 180
```
Wait of 3 minutes is used for Kubernetes to let it clean itself. Then go back to the Gitlab deployment step.   

**Redis/Gitaly/Minio/Prometheus/PostgreSQL pods failing due to permissions**  
If those pods are in loopback or errors, try inspecting them  
```
kubectl logs -f <pod-name>
```
If you see permission denied in the output on commands such as mkdir/touch etc.
You can try one of the following:  
Option 1.  
Add option to helm install command:
```
--set volumePermissions.enabled=true
```
Option 2. (If option 1 did not work)  
Add these options to helm install command:
```  
--set volumePermissions.securityContext.runAsUser=auto
--set securityContext.enabled=false
--set containerSecurityContext.enabled=false
--set shmVolume.chmod.enabled=false
```

**persistentVolume gets bound to wrong PVC**  
If you create misconfigured persistentVolume and it gets bound to wrong PVC. You might have a hard time deleting it.
```
kubectl delete pv PV-NAME
```

If Command above is stuck, try this. PVC have finalizers in their yaml descriptions which protect a bound volume from getting deleted.
```
kubectl get pv | tail -n+2 | awk '{print $1}' | xargs -I{} kubectl patch pv {} -p '{"metadata":{"finalizers": null}}'
```

This one-liner will edit finalizers which will result in completion of deleting the PV. Be wary that this might break the PVC.  

If you created a properly configured PV, and it immediately gets assigned to the same wrong PVC as before, your best bet is to start again.
```
helm uninstall gitlab; sleep 180
kubectl delete pvc --all; kubectl delete pv --all
```
Wait of 3 minutes is used for Kubernetes to let it clean itself. You should also delete all remainders of PVs or PVCs from previous deploy, then go back to the Gitlab deployment step.  

**Pod troubleshooting**
Often times there are warnings or errors which can help you in debugging.
```
kubectl describe pod <pod-name>
kubectl logs -f <pod-name>
kubectl logs -f <pod-name> <container-name>
```
If there are no helpful messages, check pods in kube-system namespace. This namespace hosts pods that run the kubernetes. You can find logs there about scheduling of resources, DNS, proxies, API calls, Networking plugins etc.
```
kubectl describe pod -n kube-system <pod-name>
kubectl logs -f -n kube-system <pod-name>
kubectl logs -f -n kube-system <pod-name> <container-name>
```
Another good place to look for logs is kubelet service running on the system.
```
systemctl status kubelet
journalctl -f -u kubelet
```
Other system tools you can use:
```
firewall-cmd # Check firewall rules etc.
# Example, list rules in all zones
firewall-cmd --list-all
# Example, reload firewall
firewall-cmd --reload
...
tcpdump # Packet capture tool, useful when inspecting node traffic
# Example, On target machine, check if HTTP/HTTPS protocol communication from your device is reaching the target machine
tcpdump -i <net-iface> "ip src <expected-source-ip> && (port 80 || port 443)"
...
systemctl # Check system services
...
ss # Check for open ports on the host system
# Show only listening sockets, both TCP and UDP with the respective PIDs using sockets and show all ports in numeric format (do not resolve numbers).
ss -tulpn
```

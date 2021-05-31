Follow this guide **ONLY** if you have the Minikube already installed. If you wish
to install the Minikube, follow [Minikube install guide](install-guides/minikube.md).  

---
## Useful Minikube deploy options
> **NOTE:** To see all the options, use **minikube start -h**.

You can specify number of nodes (virtual machines) Minikube will create when deploying cluster. This option does not work with driver=None.
```
--nodes=1
```

Number of vCPUs to use for Minikube virtual machines.
```
--cpus=4
```

Disk size to allocate for Minikube virtual machines.
```
--disk-size=64g
```

RAM size to allocate for Minikube virtual machines.
```
--memory=10g
```

Driver you want to use for Minikube. Via this you can specify whether you want to deploy cluster using
virtual machines, baremetal or in containers. KVM2 is driver for virtual machines.
```
--driver=kvm2
```

If you use KVM2 driver for Minikube, you can specify on which KVM network you want to deploy. Note that
specified KVM network has to be created beforehand. Minikube will **NOT** create the network for you.
```
--kvm-network=gitlabnet
```

This setting is used to freeze the cluster deploy on certain kubernetes version. Otherwise, newest available version would be used.
```
--kubernetes-version=1.19.9
```

Specify what container runtime to use in kubernetes cluster. Docker is the most comfortable solution. For other options, see "minikube config defaults -h"
```
--container-runtime=docker
```

Specify what CNI solution to use for Kubernetes cluster. Calico is used for performance. Other, more lightweight option is flannel.
```
--cni=calico
```

Just to demonstrate you can specify the dns domain name in Kubernetes cluster.
```
--dns-domain=k8s.local
```

Timeout for the cluster to boot up. Default is 6m0s which is too long for modern powerful hardware. You can save up some time by lowering the timeout.
```
--wait-timeout=5m0s
```

This is can be used to validate minikube run command.
```
--dry-run=true
```

## Minikube useful addons:

To see list of all available addons:
```
minikube addons list
```

Enabling kubernetes helm-tiller.
```
minikube addons enable helm-tiller
```

Enabling kubernetes ingress.
```
minikube addons enable ingress
```

Enabling kubernetes podSecurityPolicy objects.
```
minikube addons enable pod-security-policy
```

Enabling kubernetes dashboard.
```
minikube addons enable dashboard
```

Enabling metrics-server.
```
minikube addons enable metrics-server
```
## Default HW deploy values
If you don't specify driver, Minikube will start the cluster using either KVM or Docker, since they are preferred. If none of that is installed, it will try to deploy using other drivers or will fail completely. It is recommended to explicitly specify the driver.  

Minikube can be told what HW requirements to place on VMs, if KVM or Virtualbox is used as driver. default values are:  
* --cpus=2
* --disk-size=20000mb
* --memory=2g

# Deploying the VM to other disk
If you want to deploy minikube VM instance on different hard drive than that of where your system is installed, set environment variable MINIKUBE_HOME to path which is on different hard drive.
```
export MINIKUBE_HOME=<path-mounted-on-different-hard-drive>  
```

## Start single-node Minikube cluster with default values
```
minikube start --driver=kvm2
```

## Start multi-node Minikube cluster with custom values
Following command will create Minikube cluster, using KVM driver. Minikube will create 2 VMs. Both VMs will have allocated 4vCPUs, 8GB RAM and by default, 20GB of disk space.
```
minikube start --driver=kvm2 --nodes=2 --cpus=4 --memory=8g
```

## Verify the deployment
Check Kubernets components status. You should get following values:
```
daniel@pop-os:~$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
timeToStop: Nonexistent
```

Check kube-system pods. You should see all in "Running" status.
```
daniel@pop-os:~$ minikube kubectl -- get pods -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-74ff55c5b-6h954            1/1     Running   0          7m48s
kube-system   etcd-minikube                      1/1     Running   0          7m56s
kube-system   kube-apiserver-minikube            1/1     Running   0          7m56s
kube-system   kube-controller-manager-minikube   1/1     Running   0          7m56s
kube-system   kube-proxy-zkn7z                   1/1     Running   0          7m48s
kube-system   kube-scheduler-minikube            1/1     Running   0          7m56s
kube-system   storage-provisioner                1/1     Running   1          8m2s
```

If there are some components or pods failing, try to use steps in *troubleshooting*.  

## Connecting system-installed Kubectl to Minikube
If you wish to connect to Minikube cluster with system-installed kubectl, you have to use kubectl with sudo. When using with sudo, system-installed kubectl will be able to see the cluster.

## Troubleshooting
If you get some error during *minikube start*, you will usually get self-explanatory error message. You can google it and most likely find an answer on github or stack-overflow. If you cannot find a solution, you can always try one of the ways to reset minikube bellow:

If you encounter an error that breaks the Minikube, you can clean the changes and start again:
```
minikube stop
minikube delete
minikube start ...
```

If you want to stop/delete VM and it is stuck, you can always try to stop/delete the VM using the driver directly. For example, if you run VMs using Virtualbox, you can fire up Virtualbox GUI and manually stop/delete the VM.

If steps above did not help, you can hard delete Minikube files:
```
rm -rf ~/.minikube
```

> **NOTE:** Be aware that by deleting *~/.minikube*, you are deleting all ISO files and images that are required to run Minikube cluster. Your next *minikube start* command will have to re-download all these files, which is about 0.75GB of data.

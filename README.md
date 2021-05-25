This document is supposed to be your starting line into Kubernetes. Bellow are several
tips on what to take into consideration. After you are done reading the README:

1. You can find install guides for Kubernetes in [Install-Guides](Install-Guides/).  
2. Afterwards you can deploy a cluster using one of the [Cluster-Deployment Guides](Cluster-Deployment/).  
3. Lastly, you can try some [App-Deployment](App-Deployment/) on the cluster.

## HW - Hardware allocations

Kubernetes cluster is composed of several master nodes managing worker nodes doing the
hard work. On both master and worker nodes should be placed sensible HW requirements.

##### *Master node*
Workload you are going to run on your cluster does not affect how master nodes
manage worker nodes. Looking at cloud environment, following table describes how
Google Cloud decides a VM flavor for master node based on amount of worker nodes:

| Node count |   Machine name   |  vCPUs  | Memory (GB) | Storage (GB) |
| :--------: | :--------------: | :-----: | :---------: | :----------: |
| 1-5        | n1-standard-1    | 2       | 3.75        | >=375        |
| 6-10       | n1-standard-2    | 2       | 7.50        | >=375        |
| 11-100     | n1-standard-4    | 4       | 15          | >=375        |
| 101-250    | n1-standard-8    | 8       | 30          | >=375        |
| 251-500    | n1-standard-16   | 16      | 60          | >=375        |
| >500       | n1-standard-32   | 32      | 120         | >=375        |

> **NOTE**: Google Cloud treats storage as separate issue and let you specify how
much storage you want, but by default, each of the predefined VM flavors has attached
a local SSD drive with minimal capacity of 375GB.

##### *Worker node*
Worker nodes do the hard work, so in this case amount of worker nodes and their
HW specs fully depend on the underlying OS and HW requirements of applications
to be deployed.

##### *Workload on master node*
You can also allow a master node to run some applications. In this case, you should
consider general requirements for master node combined with requirements of
applications to be deployed.

## OS - Operating system
In theory, Kubernetes should be compatible with any DEB/RPM compatible Linux OS.
Bellow are lists of suggested Linux distributions.

##### *DEB compatible*
 - Ubuntu 16.04+
 - Any Ubuntu 16.04+ derivates
 - Debian 9+

##### *RPM compatible*
 - RHEL 7+
 - CentOS 7+
 - Fedora 25+


## Container runtime interface (CRI)
 Kubernetes runs applications in containers. There are many containerization solutions
 available. Commonly used by Kubernetes are:
  - containerd
  - CRI-O
  - Docker


If you are free to choose, I suggest you to use Docker as it has a lot of content
available online. (Documentation, guides, stack overflow, github issues ...)  

More on CRI [here](https://kubernetes.io/docs/setup/production-environment/container-runtimes/).


## Kubernetes cluster deployment tools
You can find many online. So far I have tried following:

##### *Minikube*
Minikube deploys (usually) single node cluster meaning the node is master and worker at the same time. Minikube can be deployed as a VM, a container, or bare-metal. In case of VM or container deploy, it does not install Kubernetes components into the system, but rather integrates it all into itself. That means you have to use kubectl integrated into Minikube to control the cluster. It does all deployment steps for you and let's you configure the details like:
 - Deployment driver: KVM, Virtualbox, Docker, Podman, None (Baremetal)
 - Container runtime: Docker, containerd, CRI-O
 - All the HW specs (in case of VM deployment)
 - Kubernetes configurations

It can be useful as PoC or learning environment. Minimal HW requirements are:
 - 2 CPUs
 - 2GB free memory
 - 20GB free disk space

Installation and deployment guide are available in the repo.  
More on Minikube [here](https://minikube.sigs.k8s.io/docs/).

##### *Kubeadm*
Kubeadm can create multi-node cluster. You have to provide HW resources for all nodes.
It allows you to join any amount of nodes be it a VM or bare-metal. You will have to
do all the steps yourself, but in exchange, you will have full control.

Installation and deployment guide are available in the repo.  
More on kubeadm [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/).

## Container network interface (CNI)
Kubernetes networking model can be implemented by many solutions, full list [here](https://kubernetes.io/docs/concepts/cluster-administration/networking/).
So far, I haved used [Calico](https://docs.projectcalico.org/getting-started/kubernetes/) - which has extensive documentation, is relatively easy to learn and has solid performance. For performance critical deployments, there are some OpenVSwitch based solutions.

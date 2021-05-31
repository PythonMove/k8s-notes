Kubernetes does not offer an implementation of network load-balancer for bare metal clusters. The implementations of Network LB that Kubernetes does ship with are all glue code that calls out to various IaaS platforms (GCP, AWS, Azure…). If you’re not running on a supported IaaS platform (GCP, AWS, Azure…), LoadBalancers will remain in the “pending” state indefinitely when created. MetalLB is a load-balancer implementation for bare metal Kubernetes clusters that solves this issue.
## Requirements
MetalLB requires the following to function:
* A Kubernetes cluster, running Kubernetes 1.13.0 or later, that does not already have network load-balancing functionality.
* A cluster network configuration that can coexist with MetalLB.
* Some IPv4 addresses for MetalLB to hand out.
* When using the BGP operating mode, you will need one or more routers capable of speaking BGP.
* Traffic on port 7946 (TCP & UDP) must be allowed between nodes, as required by memberlist.

## Installation
More details on MetalLB installation [here](https://metallb.universe.tf/installation/).
1. Edit cluster config  
Edit kube-proxy config
```
kubectl edit configmap -n kube-system kube-proxy
```
Set following settings:
```
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```
2. Apply configuration file
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
# The memberlist secret contains the secretkey to encrypt the communication between speakers for the fast dead node detection.
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```
3. Check deployment status  
Wait for metallb pods to enter into running status.
```
watch -n 10 -- kubectl get pods -n metallb-system
```
MetalLB’s pods will still start, but will remain idle until you define and deploy a configmap. See configuration step. If pods did not enter into running state, see [k8s troubleshooting guide](../../kubernetes-guides/troubleshooting.md).

## Configuration - TODO
I dropped MetalLB deployment mid-way as it turned out I won't need it. For configuration, see [Official MetalLB configuration docs](https://metallb.universe.tf/configuration/).

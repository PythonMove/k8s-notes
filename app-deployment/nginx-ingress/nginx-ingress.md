[Nginx-ingress](https://kubernetes.github.io/ingress-nginx/) is loadBalancer implementation for HTTP/HTTPS services.
## Installation
1. Apply configuration file
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/baremetal/deploy.yaml
```
2. Check deployment status  
Wait for ingress-nginx-controller pod to enter into running state.
```
watch -n 10 -- kubectl get pods -n ingress-nginx
```
If the pod entered into running state, then deployment should be successful. Otherwise, use [k8s troubleshooting guide](../../kubernetes-guides/troubleshooting.md).

More on nginx-ingress deployment here:
  * [deployment options](https://kubernetes.github.io/ingress-nginx/deploy)
  * [baremetal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#over-a-nodeport-service)

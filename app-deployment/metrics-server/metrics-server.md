Metrics server is lightweight solution for kubernetes metrics. You can find more about the Metrics server on the official [Metrics server github](https://github.com/kubernetes-sigs/metrics-server).
## Installation
1. Apply configuration file  
Command bellow installs latest release. You can find older releases [here](https://github.com/kubernetes-sigs/metrics-server/releases).
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

2. Check deployment status  
Wait for metrics-server to enter into running state.
```
watch -n 10 -- kubectl get pods -n kube-system
```

3. Try getting metrics  
Following command should return a table with cpu/memory usage.
```
kubectl top node
kubectl top pod
```
Try getting some metrics from the server manually. Check if items: [] is not empty.
```
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/default/pods
```
If all commands behaved as expected, metrics-server deployment should be successful. In case of Metrics server not behaving as expected, use [k8s troubleshooting guide](kubernetes-guides/troubleshooting.md).

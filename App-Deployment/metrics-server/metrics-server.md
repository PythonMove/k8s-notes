# Logs should tell you the metrics-server was called but did not return any metrics.
# Try getting some metrics from the server manually. Check if items: [] is not empty.
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/default/pods

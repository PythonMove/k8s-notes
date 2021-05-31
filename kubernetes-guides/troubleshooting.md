This guide covers general ideas where to look for error, warnings, debug info or any additional useful info that can help you when debugging Kubernetes deployments.
# Kubernetes troubleshooting  

### Getting info about a resource
Kubectl comes with subcommand **get** through which you can get info about resources.
Most of the times, you will debug pods, but you can get a full list of resources supported by your cluster:
```
kubectl api-resources
```
Basic usage:
```
kubectl get <resource>
```
There are some useful options you can use with **get** subcommand:  

**Option -n**
```
# -n option stands for "namespace", you can filter get output to certain namespace
kubectl get <resource> -n <namespace-name>
```

**Option -o**
```
# -o option stands for "output", you can specify a format of output.

# output "wide" shows additional information about a resource
kubectl get <resource> -o wide

# output "json" prints out json-formatted resource data
kubectl get <resource> -o json

# output "yaml" prints out yaml-formatted resource data
kubectl get <resource> -o yaml
```

**Option -l**
```
# -l option stand for "label", you can target resources having certain label
kubectl get <resource> -l <label-key>=<label-value>
```

### Describe a resource  
Describing a resource can reveal status messages, readiness checks, health checks and other resources attached to the malfunctioning resource.  

**Describe a pod**  
Describing a pod can reveal errors/warnings such as:  
* Failed to pull an image
* Health check failure
* Readiness check failure
* Failed to schedule a pod due to no nodes available (cpu/memory limitations)
* Pending status due to other resource not ready (that resource being a dependency)
* etc.

```
kubectl describe pod <pod-name>
```

### Pod logs  
If an application deployed into cluster sends out data to standard output, this data is regarded as logs. You can find there issues related to networking and system permissions.
```
# Single container pod
# To see pod name, get table of pods.
kubectl logs -f <pod-name>
# Multiple container pod
# To see container names, describe the pod.
kubectl logs -f <pod-name> <container-name>
```

### Get into pod
Every pod is based on unix-like system. These systems have shells implementations, which means you can start a shell inside the pod for further debugging. With kubectl subcommand **exec**, you can execute a command inside a pod.
```
# One time command execution
kubectl exec <pod-name> -- <command-name> <command-args>
# Set up interactive terminal
kubectl exec -it <pod-name> -- <command-name> <command-args>
# Get terminal into a pod
kubectl exec -it <pod-name> -- /bin/sh
```

### Debug networking from pod network
You can quickly deploy **busybox** app into the pod network to debug either kubernetes network issues or just to test network issues of other pod. Busybox comes bundled with networking tools such as:  
* curl
* wget
* ip
* ping
* nslookup

```
# Writing yaml deployment for busybox is tedious, using commandline is faster
kubectl run -it <name-a-pod> --image=<app-image-name> -- <command-name> <commands-args>
# Busybox command
kubectl run -it busybox --image=busybox -- /bin/sh
```

### Kubernetes management namespace
You can try to check pods in **kube-system** namespace. This namespace hosts pods that run the kubernetes. You can find logs there about scheduling of resources, DNS, proxies, API calls, Networking plugins etc.
```
kubectl describe pod -n kube-system <pod-name>
kubectl logs -f -n kube-system <pod-name>
kubectl logs -f -n kube-system <pod-name> <container-name>
```
# System troubleshooting
If troubleshooting within Kubernetes environment did not help, you can look into underlying system.
### Kubelet service
Kubelet service running on the system responds to kubernetes API calls and executes them. Each node connected in a cluster has the kubelet service running. You might find useful info in service logs.
```
# Service status
systemctl status kubelet

# Journal logs via user "kubelet"
journalctl -f -u kubelet
```

### firewall-cmd
Centos8 uses firewall-cmd as a firewall solution. You can edit via network rules on the node via this command.
```
# Service status
systemctl status firewalld

# Example, list rules in all zones
firewall-cmd --list-all

# Example, allow list of ports
firewall-cmd --zone=public --permanent --add-port={50000,54620}/tcp

# Example, allow range of ports
firewall-cmd --zone=public --permanent --add-port=30000-31000/tcp

# Example, allow services
firewall-cmd --zone=public --permanent --add-service={ssh,https}

# Example, add rich-rule
firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=172.17.0.0/16 accept"

# Example, reload firewall - you need to do this in order to apply newly added rules
firewall-cmd --reload
```

### tcpdump
Packet capture tool, bundled with most of the linux distributions.
```
# Example, check HTTP/HTTPS protocol communication
tcpdump "port 80 || port 443"

# Example, check network traffic using only specified network interface
tcpdump -i <net-iface>

# Example, check HTTP/HTTPS network traffic with specified source IP on given network interface
tcpdump -i <net-iface> "ip src <expected-source-ip> && (port 80 || port 443)"
```

### ss
Utility to check for open ports and apps using them.
```
# Example, most used variant. Shows:
# - both TCP and UDP packets
# - only listening sockets
# - processes using sockets
# - ports in numeric format (do not resolve common number ports to names e.g. HTTP -> 80)
ss -tulpn
```

### systemctl
Utility to manage system services, logs, environment etc.
```
# Show service status
systemctl status <service-name>

# List all services
systemctl list-units

# Stop a service
systemctl stop <service-name>

# Restart a service
systemctl restart <service-name>

# Start a service
systemctl start <service-name>

# Reload daemon, useful to load changes in configurations
systemctl daemon-reload

# Enable a service
systemctl enable <service-name>
```

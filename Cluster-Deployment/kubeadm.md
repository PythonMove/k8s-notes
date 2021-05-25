1. Create a control plane node (Master node):
> **NOTE:** You can choose any IPv4 of your liking. This will create a new virtual network and it will not interfere with any existing networks.
>
```
# Initialize cluster
sudo kubeadm init --pod-network-cidr <IPv4-CIDR>
```
```
# Enable management of cluster for regular users
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
2. Set up pod network addon (Master node):
> **NOTE:** Use CNI of your choice, this example uses Calico as CNI.
>
```
# Download Calico pod-network template and customize it to your needs, afterwards
# load it via kubectl
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml
kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD="can-reach=8.8.8.8"
```
```
# You can install calicoctl on worker nodes too
cd /usr/local/bin/
sudo curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.17.2/calicoctl
sudo chmod u+x calicoctl
```
3. Add worker nodes to the cluster:
> **JOIN COMMAND:** sudo kubeadm token create --print-join-command
>
```
# Add worker node to the cluster via join command, it should have following format
sudo kubeadm join <master-ip-address> --token <TOKEN> --discovery-token-ca-cert-hash sha256:<hash>
```

## Cleanup procedure (Master node)
```
# Delete configurations on all nodes
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets

# Reset the changes done by kubeadm
sudo kubeadm reset

# Clean up iptables
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# Remove worker nodes from cluster:
kubectl delete node <node name>
```

## Troubleshooting
**"[ERROR IsPrivilegedUser]: user is not running as root"**  
Run the command again, this time with admin privileges using sudo.  

**"[ERROR FileAvailable--etc-kubernetes-kubelet.conf]: /etc/kubernetes/kubelet.conf already exists"**  
```
# Delete kubelet configuration (WORKER NODE)
sudo rm /etc/kubernetes/kubelet.conf

# Stop kubelet service (WORKER NODE)
sudo systemctl stop kubelet

# Get new join command (MASTER NODE)
sudo kubeadm token create --print-join-command

# Try adding the node to the cluster again (WORKER NODE)
sudo kubeadm join <master-ip-address> --token <TOKEN> --discovery-token-ca-cert-hash sha256:<hash>
```  
**"[ERROR Port-10250]: Port 10250 is in use"**  
This error will most likely pop up paired with the previous error, so just follow steps above.  

**"[ERROR FileAvailable--etc-kubernetes-pki-ca.crt]: /etc/kubernetes/pki/ca.crt already exists"**   
```
# Remove certificates from previous session
sudo rm /etc/kubernetes/pki/ca.crt
```
**When everything fails...**  
Your best bet is to follow cleanup procedure mentioned above and try to create cluster again. Or simply use Google.

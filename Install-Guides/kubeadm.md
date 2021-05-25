> **NOTE**:
> * Follow this guide on all nodes with an user with admin privileges.
> * This guide was written for **CentOS 8**. 

1. Update the system:
```
yum check-update
yum clean all
shutdown -r now
yum update
```
2. Enable Epel repository:
```
yum -y install epel-release
yum check-update
yum clean all
shutdown -r now
```
3. Install useful utilities and kubernetes prerequisities:
```
yum -y install yum-utils vim tmux wget conntrack tc socat
```
4. Install Docker:  
```
# Set up the repository and install Docker engine
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y update && yum -y install docker-ce docker-ce-cli containerd.io
```
> **NOTE**: If you are prompted to accept GPG key, verify that the fingerprint matches
"060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35".
>
```
# Create Docker daemon configuration
mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
     "exec-opts": ["native.cgroupdriver=systemd"],
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "100m"
     },
     "storage-driver": "overlay2",
     "storage-opts": [
       "overlay2.override_kernel_check=true"
     ]
}
EOF
```
```
# Create Docker service directory
mkdir -p /etc/systemd/system/docker.service.d
```
```
# Create proxy configuration file
touch /etc/systemd/system/docker.service.d/http-proxy.conf
# Edit http-proxy in following manner:
[Service]
HTTPS_PROXY="<IPv4-Proxy-Server>"
HTTP_PROXY="<IPv4-Proxy-Server>"
NO_PROXY="<List-of-IPv4-addresses-to-exclude-from-proxying-separated-by-colon>"
```
```
# Start Docker service
systemctl enable docker.service
systemctl daemon-reload
systemctl restart docker.service
```
```
# Verify the installation
docker run hello-world
```  
5. Prepare system environment for Kubernetes:
```
# Disable swap and make the change persistent
swapoff -a
SWAP_LINE=$(sudo cat /etc/fstab|grep swap)
sed -i "s|$SWAP_LINE|#$SWAP_LINE|" /etc/fstab
```
```
# Disable selinux and make the change persistent
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
```
# Configure iptables
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1
```
```
# Configure firewall ON MASTER NODE
sudo firewall-cmd --zone=public --permanent --add-port={179,2379,2380,6443,10250,10251,10252}/tcp
sudo firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=172.31.0.205/32 accept"
sudo firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=172.17.0.0/16 accept"
sudo firewall-cmd --zone=public --permanent --add-service={ssh,cockpit,dhcpv6-client,dns,https}
sudo firewall-cmd --zone=public --permanent --add-masquerade
sudo firewall-cmd --reload
```
```
# Configure firewall ON WORKER NODE
sudo firewall-cmd --zone=public --permanent --add-port={179,10250}/tcp
sudo firewall-cmd --zone=public --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=172.31.0.205/32 accept"
sudo firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=172.17.0.0/16 accept"
sudo firewall-cmd --zone=public --permanent --add-service={ssh,cockpit,dhcpv6-client,dns,https}
sudo firewall-cmd --zone=public --permanent --add-masquerade
sudo firewall-cmd --reload
```
6. Install kubeadm
```
# Set up Kubernetes repository
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
```
```
# Install kubeadm, kubectl and kubelet
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
```

## Troubleshooting  
**"Status code: 404 for https://packages.cloud.google.com/yum/repos/kubernetes-el7-\x86_64/repodata/repomd.xml"**  
Solution found at: https://github.com/kubernetes/kubernetes/issues/37922  
Posible solution:
```
# Try replacing the kubernetes.repo with the following configuration
"""
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
"""
```

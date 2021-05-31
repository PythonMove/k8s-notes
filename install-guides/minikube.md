1. Update the system:
```
sudo yum check-update
sudo yum clean all
sudo shutdown -r now
sudo yum update
```
2. Enable Epel repository:
```
sudo yum -y install epel-release
sudo yum check-update
sudo yum clean all
sudo shutdown -r now
```
3. Install some utilites:
```
sudo yum -y install yum-utils vim tmux wget
```
4. Install Docker  
Set up the repository:
```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
Install Docker engine:
```
sudo yum -y update && sudo yum -y install docker-ce docker-ce-cli containerd.io
```
Create Docker directory:
```
sudo mkdir /etc/docker
```
Create Docker daemon configuration:
```
# Create Docker daemon configuration
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
Create Docker service directory:
```
sudo mkdir -p /etc/systemd/system/docker.service.d
```
Start the Docker service:
```
sudo systemctl enable docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```
Verify the installation:
```
sudo docker run hello-world
```

5. Install Minikube and prerequisities  
Change to working directory:
```
mkdir -p ~/minikube && cd ~/minikube
```
Install Minikube prerequisities:
```
sudo yum -y install conntrack tc socat
```
Download and install the Minikube:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -ivh minikube-latest.x86_64.rpm
```

6. Prepare the environment for Minikube  
Disable swap and make the change persistent:
```
sudo swapoff -a
SWAP_LINE=$(sudo cat /etc/fstab|grep swap)
sudo sed -i "s|$SWAP_LINE|#$SWAP_LINE|" /etc/fstab
```
Disable selinux and make the change persistent:
```
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
Configure firewall:
```
sudo firewall-cmd --add-masquerade --permanent
sudo firewall-cmd --zone=public --permanent --add-port={8080,8443,10248,10250}/tcp
sudo firewall-cmd --zone=public --permanent --add-rich-rule 'rule family=ipv4 source address=172.17.0.0/16 accept'
```

At this point, you should be done with the installation of Minikube. If you wish
to deploy a cluster using Minikube, follow the [Minikube cluster deployment guide](../cluster-deployment/minikube.md).

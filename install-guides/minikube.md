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
4. Install Docker:
  1. Set up the repository:
  ```
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ```
  2. Install Docker engine:
  ```
  sudo yum -y update && sudo yum -y install docker-ce docker-ce-cli containerd.io
  ```
  > **NOTE**: After this step:
  > * Docker service is created, but not started.
  > * Docker user group is created, but no users are added to the group.

  3. Create Docker directory:
  ```
  sudo mkdir /etc/docker
  ```
  4. Create Docker daemon configuration:
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
  5. Create Docker service directory:
  ```
  sudo mkdir -p /etc/systemd/system/docker.service.d
  ```
  6. Start the Docker service:
  ```
  sudo systemctl enable docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker.service
  ```
  7. Verify the installation:
  ```
  sudo docker run hello-world
  ```

5. Install Minikube and prerequisities:
  1. Change to working directory:
  ```
  mkdir -p ~/minikube && cd ~/minikube
  ```
  2. Install Minikube prerequisities:
  ```
  sudo yum -y install conntrack tc socat
  ```
  3. Download and install the Minikube:
  ```
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
  sudo rpm -ivh minikube-latest.x86_64.rpm
  ```

6. Prepare the environment for Minikube:
  1. Disable swap and make the change persistent:
  ```
  sudo swapoff -a
  SWAP_LINE=$(sudo cat /etc/fstab|grep swap)
  sudo sed -i "s|$SWAP_LINE|#$SWAP_LINE|" /etc/fstab
  ```
  2. Disable selinux and make the change persistent:
  ```
  sudo setenforce 0
  sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
  ```
  3. Configure firewall:
  ```
  sudo firewall-cmd --add-masquerade --permanent
  sudo firewall-cmd --zone=public --permanent --add-port={8080,8443,10248,10250}/tcp
  sudo firewall-cmd --zone=public --permanent --add-rich-rule 'rule family=ipv4 source address=172.17.0.0/16 accept'
  ```

At this point, you should be done with the installation of Minikube. If you wish
to deploy a cluster using Minikube, follow the [Minikube cluster deployment guide](cluster-deployment/minikube.md).

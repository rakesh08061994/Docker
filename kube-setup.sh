#!/bin/bash
set -e
echo "Script start here ----------------------------------------------------------------------"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl restart docker
sudo systemctl enable docker
# -------------------------------- Docker Installation complete ---------------------------------------
git clone https://github.com/Mirantis/cri-dockerd.git
source ~/.bashrc
sudo apt install -y golang
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
systemctl start kubelet
systemctl start cri-docker
mkdir -p /etc/docker/
touch /etc/docker/daemon.json
echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json
systemctl restart docker 
systemctl restart kubelet
echo "Script execution completed successfully"
echo "##########################################################################

 After this run following command on specific node
--------------On Master Node:----------------
# kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock

To start using your cluster, you need to run the following as a regular user:
  $ mkdir -p $HOME/.kube
  $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
--------------On Slave Node:-----------------
# <Master_Node_Token> --cri-socket unix:///var/run/cri-dockerd.sock
###########################################################################"

echo "##########################################################################

Run these command on Master Node with normal user for CNI Calico Plugins:-
$ sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml -O
$ kubectl apply -f calico.yaml
------ Wait five minutes & then check ----
$ kubectl get nodes -o wide

###########################################################################"
"###########################################################################
If you want to reset and resetup cluster on machine, try these steps on particular version
https://stackoverflow.com/questions/44698283/how-to-completely-uninstall-kubernetes
###########################################################################"

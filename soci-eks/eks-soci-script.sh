#!/bin/bash

## nerdctl
sudo yum install wget tar -y
wget https://github.com/containerd/nerdctl/releases/download/v1.5.0/nerdctl-1.5.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin -xvf nerdctl-1.5.0-linux-amd64.tar.gz
rm -f nerdctl-1.5.0-linux-amd64.tar.gz

## nerdctl login
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password | sudo /usr/local/bin/nerdctl login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com
sudo chmod 775 /etc/cron.hourly && sudo chown root:$(whoami) /etc/cron.hourly
echo "aws ecr get-login-password | sudo /usr/local/bin/nerdctl login --username AWS --password-stdin 956045422469.dkr.ecr.us-west-2.amazonaws.com" >> /etc/cron.hourly/ecrlogin
sudo chmod +x /etc/cron.hourly/ecrlogin

## fuse
sudo yum install fuse -y
sudo modprobe fuse
sudo bash -c 'echo "fuse" > /etc/modules-load.d/fuse.conf'

## soci-snapshooter
wget https://github.com/awslabs/soci-snapshotter/releases/download/v0.4.0/soci-snapshotter-v0.4.0-linux-amd64.tar.gz
sudo tar -C /usr/local/bin -xvf soci-snapshotter-v0.4.0-linux-amd64.tar.gz soci soci-snapshotter-grpc
rm -f soci-snapshotter-v0.4.0-linux-amd64.tar.gz

sudo curl \
  --silent \
  --show-error \
  --retry 10 \
  --retry-delay 1 \
  -L "https://raw.githubusercontent.com/awslabs/soci-snapshotter/main/soci-snapshotter.service" \
  -o "/etc/systemd/system/soci-snapshotter.service"

sudo systemctl daemon-reload
sudo systemctl enable --now soci-snapshotter
sudo systemctl status soci-snapshotter

## containerd configuration
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak
cat > config.toml <<EOF 
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"

[grpc]
address = "/run/containerd/containerd.sock"

[plugins."io.containerd.grpc.v1.cri".containerd]
snapshotter = "soci"
disable_snapshot_annotations = false
default_runtime_name = "runc"
discard_unpacked_layers = true

[plugins."io.containerd.grpc.v1.cri"]
sandbox_image = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com/eks/pause:3.5"

[plugins."io.containerd.grpc.v1.cri".registry]
config_path = "/etc/containerd/certs.d:/etc/docker/certs.d"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
runtime_type = "io.containerd.runc.v2"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
SystemdCgroup = true

[plugins."io.containerd.grpc.v1.cri".cni]
bin_dir = "/opt/cni/bin"
conf_dir = "/etc/cni/net.d"

[proxy_plugins]
 [proxy_plugins.soci]
   type = "snapshot"
   address = "/run/soci-snapshotter-grpc/soci-snapshotter-grpc.sock"
EOF
sudo mv config.toml /etc/containerd/config.toml

## containerd & kubelet restart
sudo systemctl restart containerd
sudo systemctl restart kubelet

## check status
journalctl  -n 100 -fu containerd
journalctl  -n 100 -fu soci-snapshotter
mount | grep fuse
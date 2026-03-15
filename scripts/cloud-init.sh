#!/bin/bash
# cloud-init script — runs on first boot of a fresh VPS
# installs docker, docker compose, and basic tools

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo ">>> updating packages"
apt-get update -y && apt-get upgrade -y

echo ">>> installing essentials"
apt-get install -y \
  curl \
  git \
  ufw \
  fail2ban \
  unzip \
  vim \
  htop

# docker (official method)
echo ">>> installing docker"
curl -fsSL https://get.docker.com | sh

echo ">>> installing docker compose v2 plugin"
apt-get install -y docker-compose-plugin

# enable docker on boot
systemctl enable docker
systemctl start docker

# let the non-root user use docker 
usermod -aG docker light || true


echo ">>> enabling fail2ban"
systemctl enable fail2ban
systemctl start fail2ban

echo ">>> done. reboot recommended."

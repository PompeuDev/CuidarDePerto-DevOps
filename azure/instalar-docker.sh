#!/bin/bash
# Roda DENTRO da VM Ubuntu 24.04: instala Docker Engine + Docker Compose (repositório oficial da Docker).
# Uso:  bash azure/instalar-docker.sh
set -euo pipefail

echo ">> Atualizando pacotes e instalando dependências..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

echo ">> Adicionando o repositório oficial da Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ">> Instalando Docker Engine e plugin Compose..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

echo ">> Versões instaladas:"
sudo docker --version
sudo docker compose version
echo ">> Pronto. Saia e entre de novo no SSH (exit / ssh) para usar 'docker' sem sudo."

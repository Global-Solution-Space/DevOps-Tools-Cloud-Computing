#!/usr/bin/env bash
# TerraNova - Provisionamento de Infraestrutura Azure
# Projeto: Monitoramento Agricola com NASA Power + SatVeg
# Banco : PostgreSQL 16 + PostGIS 3.5 | App: .NET (TerraNova API)

set -euo pipefail

# Variaveis do Ambiente
RG="rg-terranova"
LOCATION="canadacentral"
VNET="vnet-terranova"
SUBNET="subnet-terranova"
NSG="nsg-terranova"
VM="vm-terranova"
VM_SIZE="Standard_B2ls_v2"
ADMIN="terranova-adm"

# Grupo de Recursos
echo "[1/6] Criando Grupo de Recursos..."
az group create \
  --name "$RG" \
  --location "$LOCATION"

# VNet e Subnet
echo "[2/6] Criando VNet e Subnet..."
az network vnet create \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --name "$VNET" \
  --address-prefixes 10.20.0.0/16 \
  --subnet-name "$SUBNET" \
  --subnet-prefixes 10.20.1.0/24

# Network Security Group
echo "[3/6] Criando Network Security Group..."
az network nsg create \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --name "$NSG"

# Maquina Virtual Ubuntu 22.04 LTS
echo "[4/6] Criando Maquina Virtual Linux..."
az vm create \
  --resource-group "$RG" \
  --name "$VM" \
  --image Ubuntu2204 \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN" \
  --generate-ssh-keys \
  --output json \
  --verbose \
  --vnet-name "$VNET" \
  --subnet "$SUBNET" \
  --nsg "$NSG"

# Liberar Portas
echo "[5/6] Liberando portas necessarias..."
az vm open-port --resource-group "$RG" --name "$VM" --port 22 --priority 1000
az vm open-port --resource-group "$RG" --name "$VM" --port 8080 --priority 1010
az vm open-port --resource-group "$RG" --name "$VM" --port 5432 --priority 1020

# Instalar Docker e dependencias na VM
echo "[6/6] Instalando Docker e dependencias na VM..."
az vm run-command invoke \
  --resource-group "$RG" \
  --name "$VM" \
  --command-id RunShellScript \
  --scripts "
    set -e

    sudo apt-get update -y

    sudo apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      git \
      jq \
      nano \
      postgresql-client \
      unzip \
      wget

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      \$(. /etc/os-release && echo \"\$VERSION_CODENAME\") stable\" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin

    sudo systemctl start docker
    sudo systemctl enable docker

    sudo usermod -aG docker $ADMIN

    git --version
    curl --version
    jq --version
    psql --version
    docker --version
    docker buildx version
    docker compose version

    echo '============================================'
    echo ' Docker instalado com sucesso na VM!'
    echo '============================================'
  "

# Exibir resumo final
PUBLIC_IP=$(az vm show \
  --resource-group "$RG" \
  --name "$VM" \
  --show-details \
  --query publicIps \
  --output tsv)

echo "======================================================"
echo "  Provisionamento concluido com sucesso!"
echo "  IP Publico da VM  : $PUBLIC_IP"
echo "  Acesse via SSH    : ssh $ADMIN@$PUBLIC_IP"
echo "  API               : http://$PUBLIC_IP:8080"
echo "  Swagger           : http://$PUBLIC_IP:8080/index.html"
echo "  Postgres externo  : $PUBLIC_IP:5432 (db: terranova / user: terranova_user)"
echo "======================================================"
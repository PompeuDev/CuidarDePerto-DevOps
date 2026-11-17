#!/bin/bash
# Provisiona a infraestrutura do Cuidar de Perto no Azure via Azure CLI.
# Uso:  az login   ->   bash azure/provisionar-vm.sh
set -euo pipefail

# ---------- Variáveis ----------
RESOURCE_GROUP="rg-cuidardeperto-gs"
LOCATION="spaincentral"
VM_NAME="vm-cuidardeperto"
IMAGE="Ubuntu2404"
VM_SIZE="Standard_B2s_v2"          # 2 vCPU / 8 GiB: o Oracle Free precisa de ~2 GiB só para ele
ADMIN_USERNAME="admlnx"
VNET_NAME="vnet-cuidardeperto"
NSG_NAME="nsg-cuidardeperto"
PUBLIC_IP_NAME="pip-cuidardeperto"
APP_PORT=80                        # porta HTTP publicada pelo docker-compose
TAG_OWNER="CitizenTech"
TAG_PURPOSE="GlobalSolution-DevOps"

# A senha não fica no repositório: pode vir da variável ADMIN_PASSWORD ou é pedida aqui
if [ -z "${ADMIN_PASSWORD:-}" ]; then
  read -rsp "Senha do usuário ${ADMIN_USERNAME} da VM (12+ caracteres, maiúscula, minúscula, número e símbolo): " ADMIN_PASSWORD
  echo
fi

echo ">> [1/4] Criando grupo de recursos '${RESOURCE_GROUP}' em '${LOCATION}'..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" \
  --tags "owner=$TAG_OWNER" "purpose=$TAG_PURPOSE" --output table

echo ">> [2/4] Criando a VM '${VM_NAME}' (rede, NSG, IP público e disco são criados junto)..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VM_NAME" \
  --location "$LOCATION" \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --authentication-type password \
  --admin-username "$ADMIN_USERNAME" \
  --admin-password "$ADMIN_PASSWORD" \
  --vnet-name "$VNET_NAME" \
  --nsg "$NSG_NAME" \
  --public-ip-address "$PUBLIC_IP_NAME" \
  --public-ip-sku Standard \
  --tags "owner=$TAG_OWNER" "purpose=$TAG_PURPOSE" \
  --output table

echo ">> [3/4] Liberando a porta ${APP_PORT} (HTTP) no NSG... (a 22/SSH já é aberta pelo az vm create)"
az vm open-port --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" \
  --port "$APP_PORT" --priority 1010 --output none

echo ">> [4/4] Dados de acesso:"
PUBLIC_IP=$(az vm show -d --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query publicIps -o tsv)
echo "   IP público : ${PUBLIC_IP}"
echo "   SSH        : ssh ${ADMIN_USERNAME}@${PUBLIC_IP}"
echo "   Aplicação  : http://${PUBLIC_IP}/swagger   (disponível depois do docker compose up)"

#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

set -e  # Para abortar se algum comando falhar

echo -e "\n🔧 Atualizando lista de pacotes..."
sudo apt update -y && sudo apt upgrade -y

declare -a apt_tools=(
    "mc",
    "htop",
    "jq",
    "git",
    "curl",
    "wget",
    "apt-transport-https",
    "software-properties-common"
)

for tool in "${apt_tools[@]}"
do
    if dpkg -s "$tool" &> /dev/null; then
        echo "✅ $tool já instalado."
    else
        echo "📦 Instalando $tool via apt..."
        sudo apt install -y "$tool"
    fi
done

echo -e "\n📦 Instalando Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo -e "\n📦 Instalando .NET"
curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 9.0

echo -e "\n📦 Configurando as variáveis de ambiente do .NET"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

echo -e "\n📦 Baixando e instalando yq"
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq

echo -e "\n📦 Baixando e instalando Docker"
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker $(whoami)
newgrp docker

echo -e "\n📦 Testando o Docker"
docker container run hello-world

echo "📥 Baixando Oh My Posh..."
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Garantir que o .bashrc exista
echo "🧾 Garantindo que ~/.bashrc existe..."
touch ~/.bashrc

# Caminho do tema (ajuste se necessário)
THEME_PATH="/mnt/c/users/$(whoami)/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"

# Linha de inicialização
INIT_LINE="eval \"\$(oh-my-posh init bash --config $THEME_PATH)\""

# Adiciona ao .bashrc se ainda não existir
if ! grep -Fxq "$INIT_LINE" ~/.bashrc; then
    echo "🧩 Adicionando configuração do Oh My Posh ao ~/.bashrc"
    echo "" >> ~/.bashrc
    echo "# Oh My Posh initialization" >> ~/.bashrc
    echo "$INIT_LINE" >> ~/.bashrc
else
    echo "ℹ️ Configuração do Oh My Posh já existe no ~/.bashrc"
fi

echo -e "\n🔧 Instalando ferramentas .NET globais..."

declare -a dotnet_tools=(
    "dotnet-reportgenerator-globaltool"
    "dotnet-aspnet-codegenerator"
    "dotnet-coverage"
    "dotnet-sonarscanner"
    "dotnet-trace"
    "dotnet-counters"
    "dotnet-monitor"
    "dotnet-ef"
)

for tool in "${dotnet_tools[@]}"
do
    if dotnet tool list -g | grep -q "$tool"; then
        echo "🔄 Atualizando $tool..."
        dotnet tool update --global $tool
    else
        echo "📦 Instalando $tool..."
        dotnet tool install --global $tool
    fi
done

echo -e "\n✅ Ambiente Linux configurado com sucesso!"

exec bash

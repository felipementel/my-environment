#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

echo -e "${CYAN}Informações para configuração da conta Git${NC}"

# Solicita nome e e-mail
read -rp "Digite seu nome: " nome
read -rp "Digite seu e-mail: " email

# Converte o e-mail para minúsculas
email=$(echo "$email" | tr '[:upper:]' '[:lower:]')

echo -e "\n🔧 ${CYAN}Configurando Git... (Faça a configuração do .gitconfig manual depois)${NC}"

# Configurações globais do Git
git config --global init.defaultBranch main
git config --global user.name "$nome"
git config --global user.email "$email"



set -e  # Para abortar se algum comando falhar

echo -e "\n🔧 Atualizando lista de pacotes..."
sudo apt update -y && sudo apt upgrade -y

declare -a apt_tools=(
    "mc"
    "htop"
    "jq"
    "git"
    "curl"
    "wget"
    "apt-transport-https"
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
sudo curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 9.0

echo -e "\n📦 Configurando as variáveis de ambiente do .NET"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

echo -e "\n📦 Baixando e instalando yq"
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq

echo -e "\n📦 Baixando e instalando Docker"
sudo curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker $(whoami) # $USER
#newgrp docker

echo -e "\n📦 Testando o Docker"
sg docker -c "docker run hello-world"

echo "📥 Baixando Oh My Posh..."
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Garantir que o .bashrc exista
echo "🧾 Garantindo que ~/.bashrc existe..."
touch ~/.bashrc

# Caminho do tema (ajuste se necessário)
THEME_PATH="/mnt/c/users/$whoami/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"

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

echo -e "\n✅ Instalando o GitHub CLI"
sudo apt-add-repository https://cli.github.com/packages
sudo apt install gh

echo -e "\n✅ Removendo sources temporarios!"

declare -a temp_sources=(
    "/etc/apt/sources.list.d/archive_uri-https_cli_github_com_packages-noble.list"
    "/etc/apt/sources.list.d/docker.list"
    "/etc/apt/sources.list.d/github-cli.list"
    
)

for SOURCE_FILE in "${temp_sources[@]}"; do
    if [ -f "$SOURCE_FILE" ]; then
        if sudo rm "$SOURCE_FILE"; then
            echo "🗑️  Source removido com sucesso: $SOURCE_FILE"
        else
            echo "❌ Erro ao remover: $SOURCE_FILE"
        fi
    else
        echo "ℹ️  Source não encontrado: $SOURCE_FILE"
    fi
done

echo -e "\n✅ Ambiente Linux configurado com sucesso!"

exec bash

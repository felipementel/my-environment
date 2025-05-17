#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

echo -e "${GREEN}Informações para configuração da conta Git ${NC}"

# Solicita nome e e-mail
read -rp "Digite seu nome: " nome
read -rp "Digite seu e-mail: " email

# Converte o e-mail para minúsculas
email=$(echo "$email" | tr '[:upper:]' '[:lower:]')

echo -e "\n${YELLOW}🔧 Configurando Git... (Faça a configuração do .gitconfig manual depois) ${NC}"

# Configurações globais do Git
git config --global init.defaultBranch main
git config --global user.name "$nome"
git config --global user.email "$email"

set -e  # Para abortar se algum comando falhar

echo -e "\n${GREEN}🔧 Atualizando lista de pacotes...${NC}"
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

echo -e "\n${GREEN}📦 Instalando Azure CLI ${NC}"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo -e "\n${GREEN}📦 Instalando .NET ${NC}"
sudo curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 9.0

echo -e "\n${GREEN}📦 Configurando as variáveis de ambiente do .NET ${NC}"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

echo -e "\n${GREEN}📦 Baixando e instalando yq ${NC}"
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq

echo -e "\n${YELLOW}🐳 Verificando se o Docker já está instalado... ${NC}"

if command -v docker &> /dev/null; then
    echo "✅ Docker já está instalado. Pulando a instalação."
else
    echo -e "${GREEN}📦 Instalando Docker... ${NC}"
    sudo curl -fsSL https://get.docker.com -o install-docker.sh
    sudo sh install-docker.sh
    sudo usermod -aG docker $(whoami) # $USER
    #newgrp docker
    echo -e "\n${GREEN}✅      Docker instalado com sucesso.${NC}"
fi

echo -e "\n${YELLOW}📦 Testando o Docker ${NC}"
sg docker -c "docker run hello-world"

echo -e "\n📥${GREEN}\n Baixando Oh My Posh...${NC}"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Garantir que o .bashrc exista
echo -e "🧾 Garantindo que ~/.bashrc existe...${NC}"
touch ~/.bashrc

winUser=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
# Caminho do tema (ajuste se necessário)

THEME_PATH="/mnt/c/users/$winUser/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"

# Linha de inicialização
INIT_LINE="eval \"\$(oh-my-posh init bash --config $THEME_PATH)\""

# Adiciona ao .bashrc se ainda não existir
if ! grep -Fxq "$INIT_LINE" ~/.bashrc; then
    echo -e "\n🧩 ${GREEN} Adicionando configuração do Oh My Posh ao ~/.bashrc ${NC}"
    echo "" >> ~/.bashrc
    echo "# Oh My Posh initialization" >> ~/.bashrc
    echo "$INIT_LINE" >> ~/.bashrc
else
    echo -e "\nℹ️${YELLOW} Configuração do Oh My Posh já existe no ~/.bashrc ${NC}"
    export POSH_THEME=$"/mnt/c/Users/$winUser/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"
fi

echo -e "\n${GREEN}🔧 Instalando ferramentas .NET globais...${NC}"

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
        echo -e "\n${YELLOW}🔄 Atualizando $tool..."
        dotnet tool update --global $tool
    else
        echo -e "\n${GREEN}📦 Instalando $tool..."
        dotnet tool install --global $tool
    fi
done

echo -e "\n${GREEN}✅ Instalando o GitHub CLI ${NC}"
sudo apt-add-repository -y https://cli.github.com/packages
sudo apt install gh

echo -e "\n${GREEN}✅ Removendo sources temporarios!"

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

echo -e "\n${GREEN}✅ Ambiente Linux configurado com sucesso! ${NC}"

exec bash

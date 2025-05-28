#!/bin/bash

set -e  # Para abortar se algum comando falhar
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

### Get info to configure Git account

echo -e "${GREEN}Informações para configuração da conta Git ${NC}"

# Get Name and E-mail for config Git Account
read -rp "Digite seu nome: " nome
read -rp "Digite seu e-mail: " email

# Converte o e-mail para minúsculas
email=$(echo "$email" | tr '[:upper:]' '[:lower:]')

### Update and upgrade

echo -e "\n${GREEN}🔧 Atualizando lista de pacotes...${NC}"
sudo apt update -y && sudo apt upgrade -y

### Install main packages
echo -e "\n${BLUE}📦 Verificando os pacotes importantes para o ambiente ...${NC}"
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
        echo -e "\n${YELLOW}✅ $tool já instalado."
    else
        echo -e "\n${GREEN}📦 Instalando $tool via apt..."
        sudo apt install -y "$tool"
    fi
done

### Configure Git Account
echo -e "\n${BLUE}🔧 Configurando Git... (Faça a configuração do .gitconfig manual depois) ${NC}"

# Configurações globais do Git
git config --global init.defaultBranch main
git config --global user.name "$nome"
git config --global user.email "$email"

echo -e "\n${GREEN}🔧 Git configurado com sucesso ${NC}"

### Azure CLI
echo -e "\n${BLUE}📦 Verificando se o Azure CLI já está instalado... ${NC}"

if command -v az &> /dev/null; then
    echo -e "\n${YELLOW}✅ Azure CLI já está instalado. Pulando a instalação."
else
    echo -e "\n📦${GREEN}  Instalando Azure CLI... ${NC}"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo -e "\n${GREEN}✅ Azure CLI instalado com sucesso. ${NC}"
fi

### .NET

echo -e "\n${BLUE}📦 Verificando se o .NET já está instalado... ${NC}"

if command -v dotnet &> /dev/null; then
    echo "✅ .NET já está instalado. Pulando a instalação."
else
    echo -e "\n📦 Instalando .NET... ${NC}"
    sudo curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
    chmod +x ./dotnet-install.sh
    ./dotnet-install.sh --channel 9.0
    echo "✅ .NET instalado com sucesso. ${NC}"
fi

# ✅ Configura as variáveis de ambiente, mesmo que o .NET já esteja instalado
echo -e "\n📦 Configurando as variáveis de ambiente do .NET ${NC}"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

### yq
echo -e "\n${BLUE}📦 Verificando se o yq já está instalado... ${NC}"

if ! command -v yq &> /dev/null; then
    echo -e "\n${GREEN}📦 Baixando e instalando yq ${NC}"
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
else
    echo "✅ yq já está instalado: $(yq --version) ${NC}"
fi

### .NET Tools 
echo -e "\n${BLUE}📦 Verificando se ferramentas .NET globais já estão instalado... ${NC}"

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
        echo -e "\n${YELLOW}🔄 Atualizando $tool... ${NC}"
        dotnet tool update --global $tool
    else
        echo -e "\n${GREEN}📦 Instalando $tool... ${NC}"
        dotnet tool install --global $tool
    fi
done

### Docker 

echo -e "\n${BLUE}🐳 Verificando se o Docker já está instalado... ${NC}"

linuxUser=$(whoami)

if command -v docker &> /dev/null; then
    echo -e "\n${YELLOW}✅ Docker já está instalado. Pulando a instalação. ${NC}"
else
    echo -e "${GREEN}📦 Instalando Docker... ${NC}"
    sudo curl -fsSL https://get.docker.com -o install-docker.sh
    sudo sh install-docker.sh
    #newgrp docker
    sudo usermod -aG docker $linuxUser # $USER    
    echo -e "\n${GREEN}✅      Docker instalado com sucesso e acesso concedido ao user $linuxUser.${NC}"
fi

echo -e "\n${YELLOW}📦 Testando o Docker ${NC}"
sg docker -c "docker run hello-world"

### Oh My Posh

echo -e "\n📥${BLUE}\n Baixando Oh My Posh...${NC}"

sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Garantir que o .bashrc exista
echo -e "🧾 Garantindo que ~/.bashrc existe...${NC}"
touch ~/.bashrc

winUser=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

if [ -z "$winUser" ]; then
    echo -e "${RED}❌ Não foi possível obter o nome de usuário do Windows.${NC}"
else
    echo -e "${GREEN}🧑 Usuário do Windows detectado: $winUser${NC}"

    THEME_PATH="/mnt/c/Users/$winUser/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"

    INIT_LINE="eval \"\$(oh-my-posh init bash --config $THEME_PATH)\""

    if ! grep -Fxq "$INIT_LINE" ~/.bashrc; then
        echo -e "\n🧩 ${GREEN} Adicionando configuração do Oh My Posh ao ~/.bashrc ${NC}"
        {
            echo ""
            echo "# Oh My Posh initialization"
            echo "$INIT_LINE"
        } >> ~/.bashrc
    else
        echo -e "\nℹ️${YELLOW} Configuração do Oh My Posh já existe no ~/.bashrc ${NC}"
    fi

    # Aplica imediatamente se o script for interativo
    export POSH_THEME=$THEME_PATH
    eval "$(oh-my-posh init bash --config $THEME_PATH)"
fi

### GH Cli

echo -e "\n${BLUE}✅ Instalando o GitHub CLI ${NC}"
sudo apt-add-repository -y https://cli.github.com/packages
sudo apt install gh

### Clean remote sources

echo -e "\n${BLUE}✅ Removendo sources temporarios!${NC}"

declare -a temp_sources=(
    "/etc/apt/sources.list.d/archive_uri-https_cli_github_com_packages-noble.list"
    "/etc/apt/sources.list.d/docker.list"
    "/etc/apt/sources.list.d/github-cli.list"    
)

for SOURCE_FILE in "${temp_sources[@]}"; do
    if [ -f "$SOURCE_FILE" ]; then
        if sudo rm "$SOURCE_FILE"; then
            echo -e "\n${YELLOW}🗑️ Source removido com sucesso: $SOURCE_FILE ${NC}"
        else
            echo -e "\n${RED}❌ Erro ao remover: $SOURCE_FILE ${NC}"
        fi
    else
        echo -e "\n${YELLOW}ℹ️ Source não encontrado: $SOURCE_FILE ${NC}"
    fi
done

echo -e "\n${GREEN}✅ Ambiente Linux configurado com sucesso! ${NC}"

echo -e "\n${CYAN}🔁 Recarregando ~/.bashrc para aplicar as configurações do Oh My Posh...${NC}"
source ~/.bashrc

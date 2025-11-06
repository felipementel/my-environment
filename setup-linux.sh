#!/bin/bash

set -e  # Para abortar se algum comando falhar
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

### Get info to configure Git account

echo -e "${GREEN}Informações para configuração da conta Git ${NC}"

# Get Name and E-mail for config Git Account
read -rp "Digite seu nome: " nome
read -rp "Digite seu e-mail: " email

# Converte o e-mail para minúsculas
email=$(echo "$email" | tr '[:upper:]' '[:lower:]')

### Get Windowns user
# Detectar usuário do Windows
winUser=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Se não detectou, solicitar manualmente
if [ -z "$winUser" ]; then
    echo -e "${RED}❌ Não foi possível obter o nome de usuário do Windows automaticamente.${NC}"
    read -p "🔤 Digite o nome do usuário do Windows manualmente: " winUser
else
    echo -e "${GREEN}🧑 Usuário do Windows detectado: $winUser${NC}"
    read -p "❓ Deseja usar esse nome de usuário? (S/n): " resposta
    resposta=${resposta,,} # minúsculas

    if [[ "$resposta" == "n" || "$resposta" == "nao" || "$resposta" == "não" ]]; then
        read -p "🔤 Digite o nome do usuário do Windows manualmente: " winUser
    fi
fi

# Confirmar valor final
echo -e "${GREEN}✅ Usuário do Windows final: $winUser ${NC}"

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
        echo -e "\n${YELLOW}✅     $tool já instalado."
    else
        echo -e "\n${GREEN}📦     Instalando $tool via apt..."
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
    echo -e "\n📦${GREEN} Instalando Azure CLI... ${NC}"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo -e "\n${GREEN}✅     Azure CLI instalado com sucesso. ${NC}"
fi

### .NET

echo -e "\n${BLUE}📦 Verificando se o .NET já está instalado... ${NC}"

if command -v dotnet &> /dev/null; then
    echo -e "\n🦘${YELLOW} .NET já está instalado. Pulando a instalação.${NC}"
else
    echo -e "\n📦${YELLOW} Instalando .NET... ${NC}"
    sudo curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
    chmod +x ./dotnet-install.sh
    ./dotnet-install.sh --channel 8.0
    echo -e "\n✅${GREEN}     .NET instalado com sucesso. ${NC}"
fi

# ✅ Configura as variáveis de ambiente, mesmo que o .NET já esteja instalado
echo -e "\n📦${YELLOW} Configurando as variáveis de ambiente do .NET ${NC}"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

### yq
echo -e "\n${BLUE}📦 Verificando se o yq já está instalado... ${NC}"

if ! command -v yq &> /dev/null; then
    echo -e "\n${YELLOW}📦 Baixando e instalando yq ${NC}"
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
    echo -e "\n${GREEN}📦 yq instalado com sucesso ${NC}"
else
    echo -e "\n${YELLOW}📦 yq já está instalado: $(yq --version) ${NC}"
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

linuxUser=$(whoami)

echo -e "\n${BLUE}🐳 Verificando se o Docker já está instalado... ${NC}"
echo -e "\n${YELLOW} Estaremos utilizando o user $linuxUser para os acessos e permissões nesse step ${NC}"

if command -v docker &> /dev/null; then
    echo -e "\n${YELLOW}✅ Docker já está instalado. Pulando a instalação. ${NC}"
else
    echo -e "${GREEN}📦 Instalando Docker... ${NC}"
    sudo curl -fsSL https://get.docker.com -o install-docker.sh
    sudo sh install-docker.sh
    sudo usermod -aG docker $linuxUser # $USER
    newgrp - docker
    echo -e "\n${GREEN}✅     Docker instalado com sucesso e acesso concedido ao user $linuxUser.${NC}"
fi

echo -e "\n${YELLOW}📦 Testando o Docker ${NC}"
sg docker -c "docker run hello-world"

### Docker Compose Plugin

echo -e "\n🐳 ${BLUE}Verificando o Docker Compose Plugin...${NC}"

if docker compose version >/dev/null 2>&1; then
    echo -e "\n✅ ${GREEN}Docker Compose Plugin já está instalado.${NC}"
else
    echo -e "\n📥 ${YELLOW}Docker Compose Plugin não encontrado. Instalando...${NC}"
    sudo apt-get update -y
    sudo apt-get install -y docker-compose-plugin

    if docker compose version >/dev/null 2>&1; then
        echo -e "\n✅ ${GREEN}Docker Compose Plugin instalado com sucesso!${NC}"
    else
        echo -e "\n❌ ${RED}Falha ao instalar o Docker Compose Plugin.${NC}"
    fi
fi

### nvm

echo -e "\n ${BLUE}Verificando o NVM...${NC}"

if nvm >/dev/null 2>&1; then
    echo -e "\n✅ ${GREEN}NVM já está instalado.${NC}"
else
    echo -e "\n📥 ${YELLOW}Docker Compose Plugin não encontrado. Instalando...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    if nvm >/dev/null 2>&1; then
        echo -e "\n✅ ${GREEN}NVM instalado com sucesso!${NC}"
    else
        echo -e "\n❌ ${RED}Falha ao instalar o NVM.${NC}"
    fi
fi

### Oh My Posh
echo -e "\n ${BLUE}Verificando o Oh My Posh...${NC}"

if command -v oh-my-posh >/dev/null 2>&1; then
    echo -e "\n⚠️ ${YELLOW}Oh My Posh já está instalado.${NC}"
else
    echo -e "\n📥 ${BLUE}Baixando Oh My Posh...${NC}"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
    echo -e "\n✅ ${GREEN}Oh My Posh instalado com sucesso.${NC}"
fi

# Garantir que o .bashrc exista
echo -e "🧾 ${YELLOW}Garantindo que ~/.bashrc existe...${NC}"
touch ~/.bashrc

echo -e "🧾 ${YELLOW}Estamos utilizando o usuário: $winUser${NC}"

THEME_PATH="/mnt/c/Users/$winUser/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json"
INIT_LINE="eval \"\$(oh-my-posh init bash --config $THEME_PATH)\""

if ! grep -Fxq "$INIT_LINE" ~/.bashrc; then
    echo -e "\n🧩 ${GREEN}Adicionando configuração do Oh My Posh ao ~/.bashrc${NC}"
    {
        echo ""
        echo "# Oh My Posh initialization"
        echo "$INIT_LINE"
    } >> ~/.bashrc
else
    echo -e "\nℹ️ ${YELLOW}Configuração do Oh My Posh já existe no ~/.bashrc${NC}"
fi

# Aplica imediatamente se o script for interativo
if [ -f "$THEME_PATH" ]; then
    export POSH_THEME=$THEME_PATH
    eval "$(oh-my-posh init bash --config $THEME_PATH)"
    echo -e "✨ ${GREEN}Oh My Posh aplicado com o tema: $THEME_PATH${NC}"
else
    echo -e "❌ ${RED}Tema não encontrado em: $THEME_PATH${NC}"
fi


### GH Cli
echo -e "\n${BLUE}📦 Verificando se o GitHub CLI já esta instalado... ${NC}"

if command -v gh >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  GitHub CLI já está instalado.${NC}"
else
    echo -e "\n${GREEN}✅ Instalando o GitHub CLI...${NC}"
    sudo apt-add-repository -y https://cli.github.com/packages
    sudo apt install -y gh
    echo -e "${GREEN}✅ GitHub CLI instalado com sucesso.${NC}"
fi

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

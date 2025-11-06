<!--# 1. Chocolatey :boom:

+ Abra o powershell como adminstrador;
+ Execute o comando abaixo;

 # Chocolatey
````
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/felipementel/my-environment/main/chocolatey.ps1'))
````
-->

# Guia para setup de máquinas

## Windows

> [!WARNING]
> Antes de executar esse script:
> - Instale o PowershellCore via winget (winget install --id Microsoft.Powershell --source winget)
> - Aceite os termos
> - Copie o comando abaixo no PowershellCore e execute-o

### Pronto, pode executar o comando abaixo

````
Set-ExecutionPolicy Bypass -Scope Process -Force; $webClient = New-Object System.Net.WebClient; $webClient.CachePolicy = New-Object System.Net.Cache.RequestCachePolicy([System.Net.Cache.RequestCacheLevel]::NoCacheNoStore); iex ($webClient.DownloadString("https://raw.githubusercontent.com/birarodrigues/my-environment/main/winget.ps1"))
````

## Linux
> [!WARNING]
> Antes de começar, execute esses comandos para habilitar features no windows
> 
> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
> 
> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

### Pronto, pode executar o comando abaixo
````
/bin/bash -c "$(curl -fsSL -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/birarodrigues/my-environment/main/setup-linux.sh)"
````

PS: Lembrar de trocar o path do PowerShell Core no Windows Terminal para C:\Program Files\PowerShell\7\pwsh.exe

# O que instalar e configurar no Windows? 🪟
## 2. Habilitar Windows + V :notes:

> [!IMPORTANT]
> Configurar Fonte no terminal de forma manual !!!

# O que instalar e configurar no WSL2 Ubuntu? 🐧
### Diversos
````
sudo apt-get install mc htop jq dotnet-interactive && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
````
### .NET
````
curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
````
````
chmod +x ./dotnet-install.sh
````
````
./dotnet-install.sh --channel 9.0
````
### configure as variaveis de ambiente
````
export DOTNET_ROOT=$HOME/.dotnet
````
````
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
````
### Kubernetes
````
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
````
````
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
````
### yq
````
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
````
````
sudo chmod a+x /usr/local/bin/yq
````
### Docker
````
https://get.docker.com/
````
Para testar:
````
docker container run hello-world
````

> [!WARNING]
> Caso dê problema de permissão, execute os comandos abaixo

Add docker group
````
sudo groupadd docker
````
Add your current user to docker group
````
sudo usermod -aG docker $USER
````
Switch session to docker group
````
newgrp - docker
````
Run an example to test
````
docker run hello-world
````
---
## Oh My Posh
````
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
````
````
sudo chmod +x /usr/local/bin/oh-my-posh
````
Agora precisamos criar os arquivos que ficam as configurações
````
touch ~/.bashrc
````
````
vi ~/.bashrc
````
Coloque esses valores dentro do arquivo
````
eval "$(oh-my-posh init bash --config /mnt/c/users/felipe.augusto/AppData/Local/Programs/oh-my-posh/themes/craver.omp.json)"
````
Saia do modo SU
````
exit
````
Recarregue o terminal
````
exec bash
````

## GitHub CLI
````
sudo apt-add-repository https://cli.github.com/packages
````
````
sudo apt update
````
````
sudo apt install gh
````
> [!IMPORTANT]
> Configurar Fonte no terminal de forma manual !!!

### Configuração do WSL NetworkMode Mirrored (espelhada)

````
@"
[wsl2]
networkingMode=mirrored
"@ | Out-File "$env:USERPROFILE\.wslconfig" -Encoding ASCII
````

> Git
````
eval "$(oh-my-posh init bash --config $HOME/AppData/Local/Programs/oh-my-posh/themes/clean-detailed.omp.json)"
````

# 6. O que instalar via npm? :telephone_receiver:

````node
npm -g i typescript ts-node postman newman-parallel spectral
````
List global installed packages:
````node
npm list -g --depth 0
````

# 7. Plugins no Visual Studio :mushroom:
> Sonar Lint

> Fine Code Coverage

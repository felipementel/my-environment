# 1. Chocolatey :boom:

+ Abra o powershell como adminstrador;
+ Execute o comando abaixo;

# Chocolatey
````
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/felipementel/my-environment/main/chocolatey.ps1'))
````
# Winget
````
Set-ExecutionPolicy Bypass -Scope Process -Force; $webClient = New-Object System.Net.WebClient; $webClient.CachePolicy = New-Object System.Net.Cache.RequestCachePolicy([System.Net.Cache.RequestCacheLevel]::NoCacheNoStore); iex ($webClient.DownloadString("https://raw.githubusercontent.com/felipementel/my-environment/main/winget.ps1"))
````
+ Faça um café.

PS: Lembrar de trocar o path do PowerShell Core no Windows Terminal para C:\Program Files\PowerShell\7\pwsh.exe

# O que instalar e configurar no Windows? 🪟
## 2. Habilitar Windows + V :notes:

## 3. Configurar no git :cop:

````git
git config --global init.defaultBranch main

git config --global user.name 'Felipe Augusto'
git config user.email 'EMAIL' (por pasta de projeto)
````
## Windows / PowerShell Core

### Install Terminal Icons

````
Install-Module -Name Terminal-Icons -Repository PSGallery
````
### Install OhMyPosh on Windows
````
oh-my-posh font install
````
  OU instale direto a fonte
````
oh-my-posh font install meslo
````
````     
notepad $PROFILE
````
Se não conseguir criar o arquivo, execute o comando abaixo primeiro e depois execute o comando acima
````   
New-Item -Path $PROFILE -Type File -Force
````
### Feito a criação do arquivo, adicione os itens abaixo no arquivo
````
oh-my-posh init pwsh --config 'C:\Users\felipe.augusto\AppData\Local\Programs\oh-my-posh\themes\craver.omp.json' | Invoke-Expression
Import-Module -Name Terminal-Icons
````

### Comando para recarregar:
````
. $PROFILE
````

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

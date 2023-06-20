# Chocolatey

+ Abra o powershell como adminstrador;
+ Execute o comando abaixo;

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/felipementel/my-environment/main/install.ps1'))
    
    
+ Faça um café.

PS: Lembrar de trocar o path do PowerShell Core no Windows Terminal para C:\Program Files\PowerShell\7\pwsh.exe

> Habilitar: Windows + V

# O que configurar no git

````git
git config --global init.defaultBranch main

git config --global user.name 'Felipe Augusto'
git config user.email 'EMAIL' (por pasta de projeto)
````

# O que instalar no WSL2?
### apt-get install 
````
mc
htop
docker.io
docker-compose
kubernetes-cli
helm
azure-cli
dotnet-sdk-7.0
````

# Como deixar o terminal chic?
> Oh my Posh
````url
https://ohmyposh.dev/
````
+ Icones para o terminal.
+  Rodar o comando o powershell
```
Install-Module -Name Terminal-Icons -Repository PSGallery
```
Depois alterar o arquivo de profile. Digitar o comando:
```
notepad $PROFILE
```
Adicionar o item
```
Import-Module -Name Terminal-Icons
```

# O que instalar via npm?

````node
npm -g i typescript ts-node
````
List global installed packages: 
````node
npm list -g --depth 0
````

# Plugins no Visual Studio
> Sonar Lint

> Fine Code Coverage

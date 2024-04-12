# 1. Chocolatey :boom:

+ Abra o powershell como adminstrador;
+ Execute o comando abaixo;

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/felipementel/my-environment/main/install.ps1'))

+ Faça um café.

PS: Lembrar de trocar o path do PowerShell Core no Windows Terminal para C:\Program Files\PowerShell\7\pwsh.exe

# 2. Habilitar Windows + V :notes:

# 3. Configurar no git :cop:

````git
git config --global init.defaultBranch main

git config --global user.name 'Felipe Augusto'
git config user.email 'EMAIL' (por pasta de projeto)
````

# 4. O que instalar no WSL2? :triangular_flag_on_post:
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

# 5. Como deixar o terminal chic? :dizzy:
> Oh my Posh
````url
https://ohmyposh.dev/
````
### 5.1 Icones para o terminal. :shell:
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
oh-my-posh init pwsh --config 'C:\Users\<USER_NAME>\AppData\Local\Programs\oh-my-posh\themes\slim.omp.json' | Invoke-Expression

Import-Module -Name Terminal-Icons

```
### Git & WSL-2
````
touch .bashrc
````
````
vi .bashrc
````
> WSL-2
````
eval "$(oh-my-posh init bash --config ~/sim-web.omp.json)"
````
> Git
````
eval "$(oh-my-posh --init --shell bash --config $HOME/AppData/Local/Programs/oh-my-posh/themes/clean-detailed.omp.json)"
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

#https://github.com/JanDeDobbeleer/oh-my-posh
# npm
# npm -g i typescript ts-node


dotnet tool install --global dotnet-reportgenerator-globaltool
dotnet tool install --global dotnet-trace
dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-aspnet-codegenerator
dotnet tool install --global dotnet-counters
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-monitor

<# chocolatey setup #> 
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
​
<# allowing globally confirmation #> 
choco feature enable -n=allowGlobalConfirmation;

<# poll #>
@(
"git"
,"dotnetcore-sdk"
,"dotnet-6.0-sdk"
,"dotnetcore-sdk"
,"microsoft-edge"
,"visualstudio2022enterprise"
,"azure-functions-core-tools-4 --params "'/x64'""
,"microsoft-windows-terminal"
,"azure-cli"
,"gh"
,"azurepowershell"
,"azcopy"
,"wireshark"
,"westwindwebsurge"
,"sql-server-management-studio"
,"robo3t"
,"azure-data-studio"
,"dbeaver"
,"mobaxterm"
,"nodejs-lts"
,"nvm"
,"postman"
,"vim"
,"microsoft-teams"
,"terraform"
,"kubernetes-cli"
,"kubernetes-helm"
,"lens") + ($pins = @("vscode")) | % { choco install $_ };

<# avoiding future upgrades of these following programs. #> $pins | % { choco pin add -n="$_" }; 

<# excluded 
,"dotnet-5.0-sdk"
,"archi"
,"cmder"
,"hyper"
,"netfx-4.8-devpack"
,"notepadplusplus"
,"sublimetext3"
,"typora"
,"docker-desktop"
#>

#https://github.com/JanDeDobbeleer/oh-my-posh

dotnet tool install --global dotnet-reportgenerator-globaltool
dotnet tool install --global dotnet-trace
dotnet tool install --global dotnet-sonarscanner

<# chocolatey setup #> 
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
​
<# allowing globally confirmation #> 
choco feature enable -n=allowGlobalConfirmation;

<# programs to install #>
@(
"git"
,"dotnet-5.0-sdk"
,"dotnetcore-sdk"
,"microsoft-edge"
,"visualstudio2019professional"
,"azure-functions-core-tools-3 --params "'/x64'""
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
,"mobaxterm"
,"docker-desktop"
,"nodejs-lts"
,"nvm"
,"postman"
,"vim"
,"microsoft-teams"
,"terraform") + ($pins = @("vscode")) | % { choco install $_ };

<# avoiding future upgrades of these following programs. #> $pins | % { choco pin add -n="$_" }; 

<# excluded 
,"archi"
,"cmder"
,"hyper"
,"netfx-4.8-devpack"
,"notepadplusplus"
,"sublimetext3"
,"typora"
#>

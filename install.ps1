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
,"dotpeek"
,"ngrok"
,"visualstudio2022enterprise"
,"microsoft-windows-terminal"
,"azure-cli"
,"microsoftazurestorageexplorer"
,"microsoft-openjdk"
,"azcopy"
,"westwindwebsurge"
,"sql-server-management-studio"
,"robo3t"
,"azure-data-studio"
,"dbeaver"
,"mobaxterm"
,"nvm"
,"postman"
,"terraform"
,"kubernetes-cli"
,"kubernetes-helm"
,"lens"
,"zoomit"
) + ($pins = @("vscode")) | % { choco install $_ };

<# avoiding future upgrades of these following programs. #> $pins | % { choco pin add -n="$_" }; 

dotnet tool install dotnet-reportgenerator-globaltool --global
dotnet tool install dotnet-trace --global
dotnet tool install dotnet-sonarscanner --global
dotnet tool install dotnet-aspnet-codegenerator --global
dotnet tool install dotnet-counters --global
dotnet tool install dotnet-ef --global
dotnet tool install dotnet-monitor --global

<# excluded 
,"azure-functions-core-tools-4 --params "'/x64'""
,"microsoft-edge"
,"microsoft-teams"
,"gh"
,"azurepowershell"
,"wireshark"
,"nodejs-lts"
,"dotnet-5.0-sdk"
,"archi"
,"cmder"
,"hyper"
,"netfx-4.8-devpack"
,"notepadplusplus"
,"sublimetext3"
,"typora"
,"docker-desktop"
,"vim"
,"screenpresso"
#>

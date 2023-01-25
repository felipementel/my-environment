<# chocolatey setup #> 
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
​
<# allowing globally confirmation #> 
choco feature enable -n=allowGlobalConfirmation;

<# poll #>
@(
"git"
"dotnet-7.0-sdk",
"dotnet-6.0-sdk",
"dotnetcore-sdk",
"dotpeek",
"ngrok",
"visualstudio2022enterprise",
"microsoft-windows-terminal",
"azure-cli",
"powershell-core",
"microsoftazurestorageexplorer",
"microsoft-openjdk",
"azcopy",
"westwindwebsurge",
"sql-server-management-studio",
"robo3t",
"azure-data-studio",
"dbeaver",
"mobaxterm",
"nvm",
"yarn",
"postman",
"terraform",
"kubernetes-cli",
"kubernetes-helm",
"lens",
"zoomit",
"k-litecodecpackfull") + 
  ($pins = @(
  "microsoft-windows-terminal", 
  "vscode", 
  "robo3t", 
  "visualstudio2022enterprise",
  "azure-data-studio",
  "postman")) | 
% { choco install $_ };

<# avoiding future upgrades of these following programs. #> $pins | % { choco pin add -n="$_" }; 

. $PROFILE

dotnet tool install --global dotnet-reportgenerator-globaltool
dotnet tool install --global dotnet-aspnet-codegenerator
dotnet tool install --global dotnet-coverage
dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-trace

dotnet tool install --global dotnet-counters
dotnet tool install --global dotnet-monitor
dotnet tool install --global dotnet-ef

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

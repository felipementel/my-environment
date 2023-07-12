<# chocolatey setup #> 
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
​
<# allowing globally confirmation #> 
choco feature enable -n=allowGlobalConfirmation;

<# poll #>
@(
"git"
"dotnet-7.0-sdk",
"visualstudio2022community",
"microsoft-windows-terminal",
"powershell-core",
"westwindwebsurge",
"robo3t",
"nvm",
"postman",
"zoomit") + 
  ($pins = @(
  "microsoft-windows-terminal", 
  "vscode", 
  "robo3t", 
  "visualstudio2022community",
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

. $PROFILE

git config --global init.defaultBranch main

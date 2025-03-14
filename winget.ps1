winget install --id CoreyButler.NVMforWindows --source winget ; `
winget install --id Git.Git --source winget; `
winget install --id GitHub.cli --source winget; `
winget install --id Microsoft.Azure.StorageExplorer ; `
winget install --id Microsoft.AzureCLI --source winget; `
winget install --id k6.k6 --source winget; `
winget install --id Microsoft.OpenJDK.21 --source winget; `
winget install --id Microsoft.VisualStudioCode --source winget; `
winget install --id Microsoft.VisualStudio.2022.Enterprise --source winget; `
winget install --id CodecGuide.K-LiteCodecPack.Standard --source winget; `
winget install --id 3TSoftwareLabs.Robo3T --source winget; `
winget install --id Microsoft.DotNet.SDK.8 --source winget; `
winget install --id Microsoft.DotNet.SDK.9 --source winget; `
winget install --id Logitech.LogiTune --source winget; `
winget install --id Mobatek.MobaXterm --source winget; `
winget install --id JanDeDobbeleer.OhMyPosh --source winget; `
winget install --id Postman.Postman --source winget; `
winget install --id Zoom.Zoom.EXE --source winget; `
winget install --id Microsoft.AzureDataStudio; `
winget install --id JanDeDobbeleer.OhMyPosh --soruce winget; `
winget install --id Telegram.TelegramDesktop --source winget;
winget install --id Insomnia.Insomnia --source winget;
winget install --id DevToys-app.DevToys --source winget;
winget install --id dbeaver.dbeaver --source winget;

& $PROFILE

dotnet tool install --global dotnet-reportgenerator-globaltool
dotnet tool install --global dotnet-aspnet-codegenerator
dotnet tool install --global dotnet-coverage
dotnet tool install --global dotnet-sonarscanner
dotnet tool install --global dotnet-trace
dotnet tool install --global dotnet-counters
dotnet tool install --global dotnet-monitor
dotnet tool install --global dotnet-ef
dotnet tool install --global Microsoft.dotnet-interactive

& $PROFILE

gh extension install github/gh-copilot

& $PROFILE

Update-Help

& $PROFILE

git config --global init.defaultBranch main

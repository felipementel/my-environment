$packages = @(
    "CoreyButler.NVMforWindows",
    "Git.Git",
    "GitHub.cli",
    "Microsoft.Azure.StorageExplorer",
    "Microsoft.AzureCLI",
    "k6.k6",
    "Microsoft.OpenJDK.21",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.2022.Enterprise",
    "CodecGuide.K-LiteCodecPack.Standard",
    "3TSoftwareLabs.Robo3T",
    "Microsoft.DotNet.SDK.8",
    "Microsoft.DotNet.SDK.9",
    "Logitech.LogiTune",
    "Mobatek.MobaXterm",
    "JanDeDobbeleer.OhMyPosh",
    "Postman.Postman",
    "Zoom.Zoom.EXE",
    "Microsoft.AzureDataStudio",
    "Telegram.TelegramDesktop",
    "Insomnia.Insomnia",
    "DevToys-app.DevToys",
    "dbeaver.dbeaver"
)

foreach ($package in $packages) {
    winget install --id $package --source winget
}

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

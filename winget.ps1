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
    "Microsoft.PowershellCore",
    "Logitech.LogiTune",
    "Mobatek.MobaXterm",
    "JanDeDobbeleer.OhMyPosh",
    "Postman.Postman",
    "Zoom.Zoom.EXE",
    "Telegram.TelegramDesktop",
    "Insomnia.Insomnia",
    "DevToys-app.DevToys",
    "dbeaver.dbeaver"
)

foreach ($package in $packages) {
    winget install --id $package --source winget
}

& $PROFILE

$packagesDotNet = @(
    "dotnet-reportgenerator-globaltool",
    "dotnet-aspnet-codegenerator",
    "dotnet-coverage",
    "dotnet-sonarscanner",
    "dotnet-trace",
    "dotnet-counters",
    "dotnet-monitor",
    "dotnet-ef",
    "Microsoft.dotnet-interactive"
)

foreach ($package in $packagesDotNet) {
    dotnet tool install --global $package
}

& $PROFILE

gh extension install github/gh-copilot

& $PROFILE

Update-Help

& $PROFILE

git config --global init.defaultBranch main

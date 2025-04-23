$packages = @(
    "CoreyButler.NVMforWindows",
    "Git.Git",
    "GitHub.cli",
    "Microsoft.VisualStudioCode",
    "3TSoftwareLabs.Robo3T",
    "Microsoft.DotNet.SDK.9",
    "Microsoft.Powershell"
)

foreach ($package in $packages) {
    winget install --id $package --source winget
}

. $PROFILE

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

. $PROFILE

gh extension install github/gh-copilot

. $PROFILE

Update-Help

. $PROFILE

git config --global init.defaultBranch main

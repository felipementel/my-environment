<#
.SYNOPSIS
    Atualiza tudo que foi instalado pelo script winget.ps1
.DESCRIPTION
    - winget: todos os pacotes
    - dotnet: global tools
    - gh: extensoes (gh-copilot)
    - PowerShell: Update-Help
#>

Write-Host "`n=== Winget: atualizando todos os pacotes ===" -ForegroundColor Cyan
winget upgrade --all --source winget --include-unknown --accept-source-agreements --accept-package-agreements

Write-Host "`n=== .NET: atualizando global tools ===" -ForegroundColor Cyan
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
    dotnet tool update --global $package
}

Write-Host "`n=== GitHub CLI: atualizando extensoes (gh-copilot, etc.) ===" -ForegroundColor Cyan
gh extension upgrade --all

Write-Host "`n=== PowerShell: atualizando help ===" -ForegroundColor Cyan
Update-Help -ErrorAction SilentlyContinue

& $PROFILE

Write-Host "`n=== Concluido! ===" -ForegroundColor Green

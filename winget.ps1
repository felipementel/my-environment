# Lista de pacotes a instalar via Winget
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
    "Microsoft.Powershell",
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

Write-Host "🔧 Instalando pacotes via Winget..." -ForegroundColor Cyan
foreach ($package in $packages) {
    if (-not (winget list --id $package)) {
        Write-Host "📦 Instalando $package..." -ForegroundColor Yellow
        winget install --id $package --source winget --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "✅ $package já está instalado." -ForegroundColor Green
    }
}

# Recarregar o perfil para garantir que o .NET esteja disponível no PATH
Write-Host "`n🔄 Recarregando perfil do PowerShell após instalação de SDKs..." -ForegroundColor Cyan
if (Test-Path $PROFILE) {
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar $PROFILE: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️ Criando arquivo de perfil do PowerShell vazio..." -ForegroundColor Yellow
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

# Ferramentas .NET globais
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

Write-Host "`n🔧 Instalando ferramentas .NET globais..." -ForegroundColor Cyan
foreach ($package in $packagesDotNet) {
    if (dotnet tool list -g | Select-String $package) {
        Write-Host "♻️ Atualizando $package..." -ForegroundColor Yellow
        dotnet tool update --global $package
    } else {
        Write-Host "📦 Instalando $package..." -ForegroundColor Yellow
        dotnet tool install --global $package
    }
}

# Extensão GitHub CLI Copilot
Write-Host "`n🤖 Instalando extensão Copilot do GitHub CLI..." -ForegroundColor Cyan
gh extension install github/gh-copilot

# Atualizar ajuda do PowerShell
Write-Host "`n📚 Atualizando ajuda do PowerShell..." -ForegroundColor Cyan
Update-Help -Force -ErrorAction SilentlyContinue

# Configuração global do Git
Write-Host "`n⚙️ Configurando Git..." -ForegroundColor Cyan
git config --global init.defaultBranch main

# Recarregar perfil final
Write-Host "`n🔄 Recarregando perfil do PowerShell (final)..." -ForegroundColor Cyan
if (Test-Path $PROFILE) {
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar $PROFILE: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️ Arquivo de perfil do PowerShell ainda não existe." -ForegroundColor Yellow
}

Write-Host "`n✅ Ambiente de desenvolvimento configurado com sucesso!" -ForegroundColor Green
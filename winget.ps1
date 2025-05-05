# Lista de pacotes a instalar via Winget
$packages = @(
    @{ Id = "CoreyButler.NVMforWindows" },
    @{ Id = "Git.Git" },
    @{ Id = "GitHub.cli" },
    @{ Id = "Microsoft.Azure.StorageExplorer" },
    @{ Id = "Microsoft.AzureCLI" },
    @{ Id = "k6.k6" },
    @{ Id = "Microsoft.OpenJDK.21" },
    @{ Id = "Microsoft.VisualStudioCode" },
    @{ Id = "Microsoft.VisualStudio.2022.Enterprise" },
    @{ Id = "CodecGuide.K-LiteCodecPack.Standard" },
    @{ Id = "3TSoftwareLabs.Studio3T" },
    @{ Id = "Microsoft.DotNet.SDK.8" },
    @{ Id = "Microsoft.DotNet.SDK.9" },
    @{ Id = "Microsoft.Powershell" },
    @{ Id = "Logitech.LogiTune" },
    @{ Id = "Mobatek.MobaXterm" },
    @{ Id = "JanDeDobbeleer.OhMyPosh" },
    @{ Id = "Postman.Postman" },
    @{ Id = "Zoom.Zoom.EXE" },
    @{ Id = "Telegram.TelegramDesktop" },
    @{ Id = "Insomnia.Insomnia" },
    @{ Id = "DevToys-app.DevToys" },
    @{ Id = "dbeaver.dbeaver" }
)

Write-Host "🔧 Instalando pacotes via Winget..." -ForegroundColor Cyan
foreach ($pkg in $packages) {
    $wingetFound = winget list --id $pkg.Id | Out-String | Select-String $pkg.Id

    if ($wingetFound) {
        Write-Host "✅ $($pkg.Id) já está instalado." -ForegroundColor Green
    } else {
        Write-Host "📦 Instalando $($pkg.Id)..." -ForegroundColor Yellow
        winget install --id $($pkg.Id) --source winget --accept-package-agreements --accept-source-agreements
    }
}

# Recarregar o perfil para garantir que o .NET esteja disponível no PATH
Write-Host "`n🔄 Recarregando perfil do PowerShell após instalação de SDKs..." -ForegroundColor Cyan
if (Test-Path $PROFILE) {
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar `$PROFILE: $_" -ForegroundColor Red
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
        Write-Host "🔄 Atualizando $package..." -ForegroundColor Yellow
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
Write-Host "`n🔧 Configurando Git..." -ForegroundColor Cyan
git config --global init.defaultBranch main

# Recarregar perfil final
Write-Host "`n🔄 Recarregando perfil do PowerShell (final)..." -ForegroundColor Cyan
if (Test-Path $PROFILE) {
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar `$PROFILE: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️ Arquivo de perfil do PowerShell ainda não existe." -ForegroundColor Yellow
}

Write-Host "`n✅ Ambiente de desenvolvimento configurado com sucesso!" -ForegroundColor Green

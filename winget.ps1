Write-Host "Informações para configuração da conta Git"

$nome = Read-Host "Digite seu nome: "
$email = (Read-Host "Digite seu e-mail: ").ToLower()

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
    @{ Id = "Microsoft.dotnet-interactive" },
    @{ Id = "Microsoft.Powershell" },
    @{ Id = "Logitech.LogiTune" },
    @{ Id = "Mobatek.MobaXterm" },
    @{ Id = "JanDeDobbeleer.OhMyPosh" },
    @{ Id = "Postman.Postman" },
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
    "dotnet-ef"
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
Write-Host "`n🔧 Configurando Git... (Faça a configuracao do .gitignore manual depois)" -ForegroundColor Cyan
git config --global init.defaultBranch main
git config --global user.name $nome
git config --global user.email $email

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

Write-Host "`n✅ Instalando Terminal-Icons" -ForegroundColor Green
Install-Module -Name Terminal-Icons -Repository PSGallery

Write-Host "`n✅ Configurando Oh My Posh" -ForegroundColor Green

Write-Host "`n✅    Instalando a fonte meslo" -ForegroundColor Green
oh-my-posh font install meslo

Write-Host "`n✅    Cria o arquivo de perfil do PowerShell" -ForegroundColor Green
New-Item -Path $PROFILE -Type File -Force

Write-Host "`n✅    Criando conteúdo para o arquivo do perfil" -ForegroundColor Green
$conteudo = @"
oh-my-posh init pwsh --config 'C:\Users\($env:USERNAME)\AppData\Local\Programs\oh-my-posh\themes\craver.omp.json' | Invoke-Expression
Import-Module -Name Terminal-Icons
"@

Write-Host "`n✅    Escrevendo o conteúdo no arquivo do perfil" -ForegroundColor Green
Set-Content -Path $PROFILE -Value $conteudo

Write-Host "`n✅ Ambiente de desenvolvimento configurado com sucesso!" -ForegroundColor Green

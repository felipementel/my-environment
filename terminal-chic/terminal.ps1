[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "Informações para configuração da conta Git" -ForegroundColor Cyan

# Lista de pacotes a instalar via Winget
$packages = @(

    @{ Id = "GitHub.cli" },
    @{ Id = "GitHub.Copilot "},
    @{ Id = "JanDeDobbeleer.OhMyPosh" }
)

Write-Host "🔧 Instalando pacotes via Winget..." -ForegroundColor Cyan
foreach ($pkg in $packages) {
    $wingetFound = winget list --id $pkg.Id | Out-String | Select-String $pkg.Id

    if ($wingetFound) {
        Write-Host "✅ $($pkg.Id) já está instalado." -ForegroundColor Green
    } else {
        Write-Host "📦 Instalando $($pkg.Id)..." -ForegroundColor Yellow
        winget install -e --id $($pkg.Id) --source winget --accept-package-agreements --accept-source-agreements
    }
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
# $env:PATH += ";$env:USERPROFILE\AppData\Local\Microsoft\dotnet"

# Recarregar o perfil para garantir que o .NET esteja disponível no PATH
if (Test-Path $PROFILE) {
    Write-Host "`n🔄 Recarregando perfil do PowerShell após instalação de SDKs..." -ForegroundColor Cyan
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar `$PROFILE: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️ Criando arquivo de perfil do PowerShell vazio..." -ForegroundColor Yellow
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

# Atualizar ajuda do PowerShell
Write-Host "`n📚 Atualizando ajuda do PowerShell..." -ForegroundColor Cyan
Update-Help -Force -ErrorAction SilentlyContinue


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
Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Confirm:$false

Write-Host "`n✅ Configurando Oh My Posh" -ForegroundColor Green

Write-Host "`n✅    Instalando a fonte meslo" -ForegroundColor Green
oh-my-posh font install meslo

Write-Host "`n✅    Cria o arquivo de perfil do PowerShell" -ForegroundColor Green
New-Item -Path $PROFILE -Type File -Force

Write-Host "`n✅    Criando conteúdo para o arquivo do perfil" -ForegroundColor Green
$conteudo = @"
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/1_shell.omp.json' | Invoke-Expression
Import-Module -Name Terminal-Icons
"@

Write-Host "`n✅    Escrevendo o conteúdo no arquivo do perfil" -ForegroundColor Green
Set-Content -Path $PROFILE -Value $conteudo

# Recarregar perfil final
Write-Host "`n🔄 Recarregando perfil do PowerShell (final)..." -ForegroundColor Cyan
if (Test-Path $PROFILE) {
    try {
        . $PROFILE
    } catch {
        Write-Host "⚠️ Erro ao executar `$PROFILE: $_" -ForegroundColor Red
    }
}

# Lista de pacotes a instalar via Winget
$packages = @(
    @{ Id = "CoreyButler.NVMforWindows";              Executable = "$env:ProgramFiles\nodejs\nvm.exe" },
    @{ Id = "Git.Git";                                Executable = "$env:ProgramFiles\Git\bin\git.exe" },
    @{ Id = "GitHub.cli";                             Executable = "$env:ProgramFiles\GitHub CLI\gh.exe" },
    @{ Id = "Microsoft.Azure.StorageExplorer";        Executable = "$env:LOCALAPPDATA\Programs\Microsoft Azure Storage Explorer\StorageExplorer.exe" },
    @{ Id = "Microsoft.AzureCLI";                     Executable = "$env:ProgramFiles\Microsoft SDKs\Azure\CLI2\wbin\az.cmd" },
    @{ Id = "k6.k6";                                  Executable = "$env:USERPROFILE\AppData\Local\Programs\k6\k6.exe" },
    @{ Id = "Microsoft.OpenJDK.21";                   Executable = "$env:ProgramFiles\Microsoft\jdk-21.*\bin\java.exe" },
    @{ Id = "Microsoft.VisualStudioCode";             Executable = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe" },
    @{ Id = "Microsoft.VisualStudio.2022.Enterprise"; Executable = "$env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe" },
    @{ Id = "CodecGuide.K-LiteCodecPack.Standard";    Executable = "$env:ProgramFiles (x86)\K-Lite Codec Pack\Standard\CodecTweakTool.exe" },
    @{ Id = "3TSoftwareLabs.Robo3T";                  Executable = "$env:ProgramFiles\Robo 3T\robo3t.exe" },
    @{ Id = "Microsoft.DotNet.SDK.8";                 Executable = "$env:ProgramFiles\dotnet\sdk\8.*\dotnet.dll" },
    @{ Id = "Microsoft.DotNet.SDK.9";                 Executable = "$env:ProgramFiles\dotnet\sdk\9.*\dotnet.dll" },
    @{ Id = "Microsoft.Powershell";                   Executable = "$env:ProgramFiles\PowerShell\7\pwsh.exe" },
    @{ Id = "Logitech.LogiTune";                      Executable = "$env:ProgramFiles\LogiTune\LogiTune.exe" },
    @{ Id = "Mobatek.MobaXterm";                      Executable = "$env:ProgramFiles (x86)\Mobatek\MobaXterm\MobaXterm.exe" },
    @{ Id = "JanDeDobbeleer.OhMyPosh";                Executable = "$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe" },
    @{ Id = "Postman.Postman";                        Executable = "$env:LOCALAPPDATA\Postman\Postman.exe" },
    @{ Id = "Zoom.Zoom.EXE";                          Executable = "$env:LOCALAPPDATA\Zoom\bin\Zoom.exe" },
    @{ Id = "Telegram.TelegramDesktop";               Executable = "$env:LOCALAPPDATA\Programs\Telegram Desktop\Telegram.exe" },
    @{ Id = "Insomnia.Insomnia";                      Executable = "$env:LOCALAPPDATA\Programs\Insomnia\Insomnia.exe" },
    @{ Id = "DevToys-app.DevToys";                    Executable = "$env:LOCALAPPDATA\Programs\DevToys\DevToys.exe" },
    @{ Id = "dbeaver.dbeaver";                        Executable = "$env:ProgramFiles\DBeaver\dbeaver.exe" }
)

Write-Host "🔧 Instalando pacotes via Winget..." -ForegroundColor Cyan
foreach ($pkg in $packages) {
    $wingetFound = winget list --id $pkg.Id | Out-String | Select-String $pkg.Id
    $exeFound = Test-Path $pkg.Executable

    if ($wingetFound -or $exeFound) {
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
        Write-Host "⚠️ Erro ao executar `$PROFILE: $_" -ForegroundColor Red
    }
} else {
    Write-Host "ℹ️ Arquivo de perfil do PowerShell ainda não existe." -ForegroundColor Yellow
}

Write-Host "`n✅ Ambiente de desenvolvimento configurado com sucesso!" -ForegroundColor Green
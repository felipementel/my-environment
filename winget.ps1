Write-Host "Informações para configuração da conta Git" -ForegroundColor Cyan

$nome = Read-Host "Digite seu nome "
$email = (Read-Host "Digite seu e-mail ").ToLower()

# Lista de pacotes a instalar via Winget
$packages = @(
    @{ Id = "CoreyButler.NVMforWindows" },
    @{ Id = "Git.Git" },
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

## Install cURL

````
winget install cURL --id cURL.cURL --source winget
````

## Instalação do PowerShell Core

````
$scriptPath = Join-Path $env:TEMP "PowerShell-7.6.2-win-x64.msi"

Invoke-WebRequest `
    -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.6.2/PowerShell-7.6.2-win-x64.msi" `
    -OutFile $scriptPath

Start-Process msiexec.exe -ArgumentList "/i `"$scriptPath`"" -Wait
````

## Instalação dos scripts via winget
````
$scriptPath = Join-Path $env:TEMP "terminal.ps1"; curl.exe -L -o $scriptPath "https://raw.githubusercontent.com/felipementel/my-environment/refs/heads/main/terminal-chic/terminal.ps1"; if ($LASTEXITCODE -eq 0) { pwsh -ExecutionPolicy Bypass -File $scriptPath }
````

### Themes do OhMyPosh
---
https://ohmyposh.dev/docs/themes

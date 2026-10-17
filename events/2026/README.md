## Install cURL

````
winget install cURL --id cURL.cURL --source winget
````

## Instalação do PowerShell Core

````
$scriptPath = Join-Path $env:TEMP "PowerShell-7.6.1-win-x64.msi"; curl.exe -L -o $scriptPath "https://github.com/PowerShell/PowerShell/releases/download/v7.6.1/PowerShell-7.6.1-win-x64.msi"; if ($LASTEXITCODE -eq 0) { Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$scriptPath`" /qn" -Wait }
````

## Instalação dos scripts via winget
````
$scriptPath = Join-Path $env:TEMP "github-copilot-dev-days.ps1"; curl.exe -L -o $scriptPath "https://raw.githubusercontent.com/felipementel/my-environment/refs/heads/main/events/2026/github-copilot-dev-days.ps1"; if ($LASTEXITCODE -eq 0) { pwsh -ExecutionPolicy Bypass -File $scriptPath }
````

### Themes do OhMyPosh
---
https://ohmyposh.dev/docs/themes

## Powershell
````
curl.exe -L `
  -o github-copilot-dev-days.ps1 `
  https://raw.githubusercontent.com/felipementel/my-environment/refs/heads/main/events/2026/github-copilot-dev-days.ps1
````
````
pwsh -ExecutionPolicy Bypass -File .\github-copilot-dev-days.ps1
````

## Powershell Core

````
https://github.com/PowerShell/PowerShell/releases/download/v7.6.1/PowerShell-7.6.1-win-x64.zip
````

````
$scriptPath = Join-Path $env:TEMP "github-copilot-dev-days.ps1"; curl.exe -L -o $scriptPath "https://raw.githubusercontent.com/felipementel/my-environment/refs/heads/main/events/2026/github-copilot-dev-days.ps1"; if ($LASTEXITCODE -eq 0) { pwsh -ExecutionPolicy Bypass -File $scriptPath }
````

---
https://ohmyposh.dev/docs/themes

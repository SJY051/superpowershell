param(
    [switch]$Apply,
    [switch]$WhatIf,
    [string]$ProfileDirectory = "$HOME\Documents\PowerShell\profile.d",
    [string]$ProfilePath = $PROFILE.CurrentUserAllHosts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$files = @{
    '00-core.ps1' = @'
if (-not $env:XDG_CONFIG_HOME) {
    $env:XDG_CONFIG_HOME = Join-Path $HOME '.config'
}
if (-not $env:XDG_CACHE_HOME) {
    $env:XDG_CACHE_HOME = Join-Path $HOME '.cache'
}
if (-not $env:XDG_DATA_HOME) {
    $env:XDG_DATA_HOME = Join-Path $HOME '.local\share'
}

function Add-PathIfExists {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    $parts = @($env:PATH -split ';' | Where-Object { $_ })
    if ($parts -contains $Path) {
        return
    }

    $env:PATH = ($parts + $Path) -join ';'
}
'@
    '20-integrations.ps1' = @'
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Get-Command direnv -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (direnv hook pwsh | Out-String) })
}

if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -EnableAliasFuzzyHistory -ErrorAction SilentlyContinue
}
'@
    '30-aliases.ps1' = @'
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat -Option AllScope
}
if (Get-Command fd -ErrorAction SilentlyContinue) {
    Set-Alias find fd -Option AllScope
}
if (Get-Command rg -ErrorAction SilentlyContinue) {
    Set-Alias grep rg -Option AllScope
}
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Set-Alias ls eza -Option AllScope
}
'@
    '90-local.ps1' = @'
# Add local overrides here.
'@
}

$loader = @'
$profileDirectory = Join-Path $HOME 'Documents\PowerShell\profile.d'
if (Test-Path -LiteralPath $profileDirectory) {
    Get-ChildItem -LiteralPath $profileDirectory -Filter '*.ps1' -File |
        Sort-Object Name |
        ForEach-Object { . $_.FullName }
}
'@.Trim()

function Show-Preview {
    Write-Host 'Preview only. Re-run with -Apply to create the profile scaffold.'
    Write-Host ''
    Write-Host "Profile directory: $ProfileDirectory"
    Write-Host "Profile loader path: $ProfilePath"
    Write-Host ''
    Write-Host 'Files that would be created or updated:'
    foreach ($name in $files.Keys | Sort-Object) {
        Write-Host "  $(Join-Path $ProfileDirectory $name)"
    }
    Write-Host "  $ProfilePath"
}

if ($WhatIf -or -not $Apply) {
    Show-Preview
    return
}

New-Item -ItemType Directory -Force -Path $ProfileDirectory | Out-Null

foreach ($name in $files.Keys) {
    $path = Join-Path $ProfileDirectory $name
    if (Test-Path -LiteralPath $path) {
        Write-Host "Skipping (already exists): $path"
    }
    else {
        Set-Content -LiteralPath $path -Value $files[$name] -Encoding UTF8
        Write-Host "Created: $path"
    }
}

$profileParent = Split-Path -Parent $ProfilePath
if (-not (Test-Path -LiteralPath $profileParent)) {
    New-Item -ItemType Directory -Force -Path $profileParent | Out-Null
}

$existing = if (Test-Path -LiteralPath $ProfilePath) {
    Get-Content -LiteralPath $ProfilePath -Raw
}
else {
    ''
}

if ($existing -notmatch [regex]::Escape("profile.d")) {
    if (-not [string]::IsNullOrWhiteSpace($existing) -and -not $existing.EndsWith("`n")) {
        Add-Content -LiteralPath $ProfilePath -Value ''
    }
    Add-Content -LiteralPath $ProfilePath -Value $loader
}

Write-Host 'Created or updated modular profile scaffold.'
Write-Host "  $ProfileDirectory"
Write-Host "  $ProfilePath"

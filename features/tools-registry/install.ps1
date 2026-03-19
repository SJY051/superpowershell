param(
    [switch]$Apply,
    [switch]$WhatIf,
    [switch]$AddToProfile,
    [string]$TargetDirectory = "$HOME\Documents\PowerShell\profile.d",
    [string]$TargetFileName = "50-tools-registry.ps1",
    [string]$ProfilePath = $PROFILE.CurrentUserAllHosts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$featureRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceFile = Join-Path $featureRoot "tools-registry.ps1"
$targetFile = Join-Path $TargetDirectory $TargetFileName

if (-not (Test-Path -LiteralPath $sourceFile)) {
    throw "Feature source file not found: $sourceFile"
}

$profileLoader = @"
if (Test-Path -LiteralPath '$targetFile') {
    . '$targetFile'
}
"@.Trim()

function Show-Preview {
    Write-Host "Preview only. Re-run with -Apply to perform installation."
    Write-Host ""
    Write-Host "Would create directory:"
    Write-Host "  $TargetDirectory"
    Write-Host ""
    Write-Host "Would copy:"
    Write-Host "  $sourceFile"
    Write-Host "  -> $targetFile"

    if ($AddToProfile) {
        Write-Host ""
        Write-Host "Would append this loader snippet to:"
        Write-Host "  $ProfilePath"
        Write-Host ""
        Write-Host $profileLoader
    }
    else {
        Write-Host ""
        Write-Host "Profile will not be modified unless -AddToProfile is explicitly passed."
    }
}

if ($WhatIf -or -not $Apply) {
    Show-Preview
    return
}

New-Item -ItemType Directory -Force -Path $TargetDirectory | Out-Null
Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
Write-Host "Installed tools registry fragment:"
Write-Host "  $targetFile"

if ($AddToProfile) {
    $profileDirectory = Split-Path -Parent $ProfilePath
    if (-not (Test-Path -LiteralPath $profileDirectory)) {
        New-Item -ItemType Directory -Force -Path $profileDirectory | Out-Null
    }

    $existing = if (Test-Path -LiteralPath $ProfilePath) {
        Get-Content -LiteralPath $ProfilePath -Raw
    } else {
        ""
    }

    if ($existing -notmatch [regex]::Escape($targetFile)) {
        if (-not [string]::IsNullOrWhiteSpace($existing) -and -not $existing.EndsWith("`n")) {
            Add-Content -LiteralPath $ProfilePath -Value ""
        }
        Add-Content -LiteralPath $ProfilePath -Value $profileLoader
        Write-Host "Added loader snippet to profile:"
        Write-Host "  $ProfilePath"
    }
    else {
        Write-Host "Profile already references the installed fragment:"
        Write-Host "  $ProfilePath"
    }
}
else {
    Write-Host ""
    Write-Host "Manual load example:"
    Write-Host "  . '$targetFile'"
}

param(
    [switch]$Apply,
    [switch]$WhatIf,
    [ValidateSet('none','codex')]
    [string]$Preset = 'none',
    [string]$TargetDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot 'skills'

if (-not $TargetDirectory) {
    switch ($Preset) {
        'codex' { $TargetDirectory = Join-Path $HOME '.codex\skills' }
        default { $TargetDirectory = $null }
    }
}

if (-not $TargetDirectory) {
    throw 'Provide -TargetDirectory or use a supported -Preset.'
}

$skillDirs = Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object { $_.Name -ne '.system' }

if ($WhatIf -or -not $Apply) {
    Write-Host 'Preview only. Re-run with -Apply to install shipped skills.'
    Write-Host "Source: $sourceRoot"
    Write-Host "Target: $TargetDirectory"
    foreach ($dir in $skillDirs) {
        Write-Host ("  copy {0} -> {1}" -f $dir.FullName, (Join-Path $TargetDirectory $dir.Name))
    }
    return
}

New-Item -ItemType Directory -Force -Path $TargetDirectory | Out-Null

foreach ($dir in $skillDirs) {
    $target = Join-Path $TargetDirectory $dir.Name
    Copy-Item -LiteralPath $dir.FullName -Destination $target -Recurse -Force
}

Write-Host 'Installed repo skills.'
Write-Host "  $TargetDirectory"

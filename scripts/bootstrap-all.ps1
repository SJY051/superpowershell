param(
    [switch]$Apply,
    [switch]$WhatIf,
    [switch]$IncludeAgentExtras,
    [switch]$InstallToolsRegistry,
    [switch]$InstallSkills,
    [ValidateSet('none','codex')]
    [string]$SkillPreset = 'none',
    [string]$SkillTargetDirectory,
    [switch]$AcceptAgreements
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = $PSScriptRoot
$repoRoot = Split-Path -Parent $scriptRoot

function Invoke-Step {
    param(
        [string]$Label,
        [string]$FilePath,
        [string[]]$Arguments
    )

    Write-Host ''
    Write-Host "==> $Label"
    & pwsh -NoLogo -NoProfile -File $FilePath @Arguments
}

$modeArgs = if ($Apply) { @('-Apply') } else { @('-WhatIf') }
$coreArgs = @($modeArgs)
if ($AcceptAgreements) {
    $coreArgs += '-AcceptAgreements'
}

Invoke-Step -Label 'Core tool baseline' -FilePath (Join-Path $scriptRoot 'install-core-tools-winget.ps1') -Arguments $coreArgs
Invoke-Step -Label 'Profile bootstrap' -FilePath (Join-Path $scriptRoot 'bootstrap-profile.ps1') -Arguments $modeArgs
Invoke-Step -Label 'Starter tool inventory' -FilePath (Join-Path $scriptRoot 'bootstrap-tools-inventory.ps1') -Arguments $modeArgs

if ($InstallToolsRegistry) {
    Invoke-Step -Label 'Optional tools-registry feature' -FilePath (Join-Path $repoRoot 'features\tools-registry\install.ps1') -Arguments $modeArgs
}

if ($IncludeAgentExtras) {
    Invoke-Step -Label 'Optional agent extras' -FilePath (Join-Path $scriptRoot 'install-agent-extras.ps1') -Arguments $modeArgs
}

if ($InstallSkills) {
    $skillArgs = @($modeArgs)
    if ($SkillPreset -ne 'none') {
        $skillArgs += @('-Preset', $SkillPreset)
    }
    if ($SkillTargetDirectory) {
        $skillArgs += @('-TargetDirectory', $SkillTargetDirectory)
    }
    Invoke-Step -Label 'Repo skills' -FilePath (Join-Path $scriptRoot 'install-skills.ps1') -Arguments $skillArgs
}

Write-Host ''
if ($Apply) {
    Write-Host 'Bootstrap flow completed.'
}
else {
    Write-Host 'Preview completed. Re-run with -Apply when you are ready.'
}

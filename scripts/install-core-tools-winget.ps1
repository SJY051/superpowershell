param(
    [switch]$Apply,
    [switch]$AcceptAgreements,
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install App Installer / winget first, or use the documented alternative package manager path."
}

$packages = @(
    'Microsoft.PowerShell',
    'BurntSushi.ripgrep.MSVC',
    'sharkdp.fd',
    'jqlang.jq',
    'MikeFarah.yq',
    'sharkdp.bat',
    'junegunn.fzf',
    'eza-community.eza',
    'ajeetdsouza.zoxide',
    'astral-sh.uv',
    'Casey.Just',
    'direnv.direnv',
    'ducaale.xh',
    'JohnMacFarlane.Pandoc',
    'Wilfred.difftastic',
    'sharkdp.hyperfine',
    'dandavison.delta'
)

function Get-InstallArgs {
    param([string]$Id)

    $installArgs = @('install', '--id', $Id, '-e')
    if ($AcceptAgreements) {
        $installArgs += '--accept-package-agreements'
        $installArgs += '--accept-source-agreements'
    }
    return $installArgs
}

if ($WhatIf -or -not $Apply) {
    Write-Host "Preview only. Re-run with -Apply to perform installation."
    foreach ($id in $packages) {
        Write-Host ("winget " + ((Get-InstallArgs -Id $id) -join ' '))
    }
    return
}

foreach ($id in $packages) {
    Write-Host "Installing $id via winget..."
    $wingetArgs = Get-InstallArgs -Id $id
    & winget @wingetArgs
}

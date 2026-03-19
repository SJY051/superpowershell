param(
    [switch]$Apply,
    [switch]$WhatIf,
    [string]$NpmPrefix = "$HOME\.local\npm-tools"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$npmPackages = @(
    'defuddle',
    'fx'
)

$pipPackages = @(
    'jc'
)

function Show-Preview {
    Write-Host "Preview only. Re-run with -Apply to perform installation."
    Write-Host ("npm install --global --prefix `"{0}`" {1}" -f $NpmPrefix, ($npmPackages -join ' '))

    if (Get-Command uv -ErrorAction SilentlyContinue) {
        foreach ($name in $pipPackages) {
            Write-Host "uv tool install $name"
        }
    }
    elseif (Get-Command pipx -ErrorAction SilentlyContinue) {
        foreach ($name in $pipPackages) {
            Write-Host "pipx install $name"
        }
    }
    else {
        foreach ($name in $pipPackages) {
            Write-Host "python -m pip install --user $name"
        }
    }

    Write-Host ""
    Write-Host "If npm-based tools are not on PATH yet, add this directory:"
    Write-Host $NpmPrefix
}

if ($WhatIf -or -not $Apply) {
    Show-Preview
    return
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm was not found. Install Node.js/npm first or skip the npm-based extras."
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw "python was not found. Install Python first or skip the Python-based extras."
}

New-Item -ItemType Directory -Force -Path $NpmPrefix | Out-Null
Write-Host "Installing npm-based extras into $NpmPrefix ..."
npm install --global --prefix $NpmPrefix @npmPackages

if (Get-Command uv -ErrorAction SilentlyContinue) {
    foreach ($name in $pipPackages) {
        Write-Host "Installing Python tool $name via uv..."
        uv tool install $name
    }
}
elseif (Get-Command pipx -ErrorAction SilentlyContinue) {
    foreach ($name in $pipPackages) {
        Write-Host "Installing Python tool $name via pipx..."
        pipx install $name
    }
}
else {
    foreach ($name in $pipPackages) {
        Write-Host "Installing Python package $name via pip --user..."
        python -m pip install --user $name
    }
}

Write-Host ""
Write-Host "If npm-based tools are not on PATH yet, add this directory:"
Write-Host $NpmPrefix

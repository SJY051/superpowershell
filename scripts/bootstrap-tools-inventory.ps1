param(
    [switch]$Apply,
    [switch]$WhatIf,
    [string]$InventoryHome = "$HOME\.terminal-tools"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$catalog = @(
    @{ name='pwsh'; category='shell'; description='Modern PowerShell'; preferred=$true; posix='sh'; tags=@('shell','powershell'); replaces=@() },
    @{ name='rg'; category='search'; description='Recursive text search'; preferred=$true; posix='grep'; tags=@('search','text'); replaces=@('grep') },
    @{ name='fd'; category='search'; description='Recursive file discovery'; preferred=$true; posix='find'; tags=@('search','files'); replaces=@('find') },
    @{ name='bat'; category='data'; description='Readable file viewer'; preferred=$true; posix='cat'; tags=@('files','view'); replaces=@('cat') },
    @{ name='jq'; category='data'; description='JSON processor'; preferred=$true; posix='jq'; tags=@('json','data'); replaces=@() },
    @{ name='yq'; category='data'; description='YAML and config processor'; preferred=$true; posix='yq'; tags=@('yaml','config'); replaces=@() },
    @{ name='fzf'; category='navigation'; description='Fuzzy selector'; preferred=$true; posix=''; tags=@('selection','interactive'); replaces=@() },
    @{ name='eza'; category='navigation'; description='Modern directory listing'; preferred=$true; posix='ls'; tags=@('listing','files'); replaces=@('ls') },
    @{ name='zoxide'; category='navigation'; description='Directory jumping'; preferred=$true; posix='cd'; tags=@('navigation','cd'); replaces=@('cd') },
    @{ name='uv'; category='task'; description='Python runtime and tool manager'; preferred=$true; posix=''; tags=@('python','runtime'); replaces=@() },
    @{ name='just'; category='task'; description='Task runner'; preferred=$true; posix='make'; tags=@('task','runner'); replaces=@() },
    @{ name='curl'; category='network'; description='Baseline HTTP client'; preferred=$true; posix='curl'; tags=@('http','network'); replaces=@() },
    @{ name='xh'; category='network'; description='Readable HTTP client'; preferred=$false; posix=''; tags=@('http','api'); replaces=@() },
    @{ name='pandoc'; category='docs'; description='Document converter'; preferred=$true; posix=''; tags=@('docs','conversion'); replaces=@() },
    @{ name='difft'; category='vcs'; description='Structural diff tool'; preferred=$true; posix=''; tags=@('diff','review'); replaces=@() },
    @{ name='delta'; category='vcs'; description='Readable git diff pager'; preferred=$true; posix=''; tags=@('diff','git'); replaces=@() }
)

function Get-ShellCoverage {
    param([string]$Name)

    $available = @()
    foreach ($shellName in @('powershell', 'pwsh')) {
        try {
            $result = & $shellName -NoLogo -NoProfile -Command "if (Get-Command '$Name' -ErrorAction SilentlyContinue) { '$shellName' }"
            if ($LASTEXITCODE -eq 0 -and $result) {
                $available += $shellName
            }
        }
        catch {
        }
    }

    @($available | Sort-Object -Unique)
}

function Show-Preview {
    param(
        [string]$InventoryPath,
        [string]$ManualPath,
        [object[]]$Entries
    )

    Write-Host 'Preview only. Re-run with -Apply to write the starter inventory.'
    Write-Host ''
    Write-Host "Inventory file: $InventoryPath"
    Write-Host "Manual file:    $ManualPath"
    Write-Host "Entries found:  $(@($Entries).Count)"
}

$entries = @()
foreach ($item in $catalog) {
    $shells = Get-ShellCoverage -Name $item.name
    if (@($shells).Count -eq 0) {
        continue
    }

    $entries += [pscustomobject]@{
        name = $item.name
        category = $item.category
        description = $item.description
        available_in = @($shells)
        command_types = @('application')
        preferred = [bool]$item.preferred
        replaces = @($item.replaces)
        posix_analogue = if ([string]::IsNullOrWhiteSpace($item.posix)) { $null } else { $item.posix }
        tags = @($item.tags)
        notes = $null
    }
}

$inventoryPath = Join-Path $InventoryHome 'terminal-tools.json'
$manualPath = Join-Path $InventoryHome 'manual-tools.json'

if ($WhatIf -or -not $Apply) {
    Show-Preview -InventoryPath $inventoryPath -ManualPath $manualPath -Entries $entries
    return
}

New-Item -ItemType Directory -Force -Path $InventoryHome | Out-Null
$entries | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $inventoryPath -Encoding UTF8

if (-not (Test-Path -LiteralPath $manualPath)) {
    @() | ConvertTo-Json | Set-Content -LiteralPath $manualPath -Encoding UTF8
}

Write-Host 'Wrote starter tool inventory.'
Write-Host "  $inventoryPath"
Write-Host "  $manualPath"

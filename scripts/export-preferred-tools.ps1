param(
    [string]$TerminalToolsHome = "$HOME\.terminal-tools"
)

$terminalToolsJson = Join-Path $TerminalToolsHome 'terminal-tools.json'
$manualToolsJson = Join-Path $TerminalToolsHome 'manual-tools.json'

function Get-JsonArrayOrEmpty {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $raw = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    $parsed = $raw | ConvertFrom-Json -Depth 20
    if ($parsed -is [System.Collections.IEnumerable] -and -not ($parsed -is [string])) {
        return @($parsed)
    }

    return @($parsed)
}

$map = @{}

foreach ($entry in @(Get-JsonArrayOrEmpty -Path $terminalToolsJson)) {
    if ($entry.name) {
        $map[$entry.name.ToLowerInvariant()] = $entry
    }
}

foreach ($entry in @(Get-JsonArrayOrEmpty -Path $manualToolsJson)) {
    if ($entry.name) {
        $map[$entry.name.ToLowerInvariant()] = $entry
    }
}

$preferred = @(
    $map.Values |
        Where-Object { $_.preferred -eq $true } |
        Sort-Object category, name
)

$preferred | ConvertTo-Json -Depth 6

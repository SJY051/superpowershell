param(
    [switch]$IncludePaths,
    [switch]$IncludeTimestamp
)

function Get-ShellVersion {
    param([string]$Command)

    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    if (-not $cmd) {
        return $null
    }

    try {
        if ($Command -eq 'pwsh') {
            $version = @'
$PSVersionTable.PSVersion.ToString()
'@ | pwsh -NoLogo -NoProfile -Command -
        }
        elseif ($Command -eq 'powershell') {
            $version = powershell -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
        }
        else {
            $version = $null
        }
    } catch {
        $version = $null
    }

    return [pscustomobject]@{
        shell = $Command
        path = if ($IncludePaths) { $cmd.Source } else { $null }
        version = if ($version) { ($version | Out-String).Trim() } else { $null }
    }
}

$result = [pscustomobject]@{
    generated_at = if ($IncludeTimestamp) { (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz") } else { $null }
    shells = @(
        Get-ShellVersion -Command 'pwsh'
        Get-ShellVersion -Command 'powershell'
    ) | Where-Object { $_ }
    has_wsl = [bool](Get-Command wsl.exe -ErrorAction SilentlyContinue)
}

$result | ConvertTo-Json -Depth 5

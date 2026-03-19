$script:TerminalToolsHome = if ($env:TERMINAL_TOOLS_HOME -and -not [string]::IsNullOrWhiteSpace($env:TERMINAL_TOOLS_HOME)) {
    $env:TERMINAL_TOOLS_HOME
}
else {
    Join-Path $HOME ".terminal-tools"
}

$script:TerminalToolsJsonPath = Join-Path $script:TerminalToolsHome "terminal-tools.json"
$script:ManualToolsJsonPath = Join-Path $script:TerminalToolsHome "manual-tools.json"

function Test-RegistryProperty {
    param(
        $Object,
        [Parameter(Mandatory)][string]$Name
    )

    $null -ne $Object -and $Object.PSObject.Properties.Match($Name).Count -gt 0
}

function Get-RegistryString {
    param(
        $Object,
        [Parameter(Mandatory)][string]$Name
    )

    if (-not (Test-RegistryProperty -Object $Object -Name $Name)) {
        return $null
    }

    $value = $Object.$Name
    if ($null -eq $value) {
        return $null
    }

    $text = $value.ToString().Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    $text
}

function Get-RegistryStringList {
    param([object]$Value)

    $items = @()
    if ($null -eq $Value) {
        return @()
    }

    foreach ($item in @($Value)) {
        if ($null -eq $item) {
            continue
        }

        if ($item -is [System.Collections.IEnumerable] -and -not ($item -is [string])) {
            $items += @(Get-RegistryStringList -Value $item)
        }
        else {
            $items += @($item)
        }
    }

    @(
        $items |
            ForEach-Object { $_.ToString().Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Sort-Object -Unique
    )
}

function Get-RegistryBoolean {
    param(
        $Object,
        [Parameter(Mandatory)][string]$Name,
        [bool]$Default = $false
    )

    if (-not (Test-RegistryProperty -Object $Object -Name $Name)) {
        return $Default
    }

    [bool]$Object.$Name
}

function Get-JsonArrayOrEmpty {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    try {
        $raw = Get-Content -LiteralPath $Path -Raw
        if ([string]::IsNullOrWhiteSpace($raw)) {
            return @()
        }

        $parsed = $raw | ConvertFrom-Json -Depth 20
        if ($parsed -is [System.Collections.IEnumerable] -and -not ($parsed -is [string])) {
            return @($parsed)
        }

        @($parsed)
    }
    catch {
        Write-Warning "Failed to parse JSON file: $Path"
        @()
    }
}

function Merge-RegistryEntry {
    param(
        [Parameter(Mandatory)]$Base,
        $Overlay
    )

    $name = Get-RegistryString -Object $Overlay -Name "name"
    if (-not $name) {
        $name = Get-RegistryString -Object $Base -Name "name"
    }

    $category = Get-RegistryString -Object $Overlay -Name "category"
    if (-not $category) {
        $category = Get-RegistryString -Object $Base -Name "category"
    }
    if (-not $category) {
        $category = "custom"
    }

    $description = Get-RegistryString -Object $Overlay -Name "description"
    if (-not $description) {
        $description = Get-RegistryString -Object $Base -Name "description"
    }
    if (-not $description) {
        $description = "Manually added tool"
    }

    $availableIn = @(
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Base -Name "available_in") { $Base.available_in })),
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Overlay -Name "available_in") { $Overlay.available_in }))
    ) | Where-Object { $_ } | Sort-Object -Unique
    if (@($availableIn).Count -eq 0) {
        $availableIn = @("powershell", "pwsh")
    }

    $commandTypes = @(
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Base -Name "command_types") { $Base.command_types })),
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Overlay -Name "command_types") { $Overlay.command_types }))
    ) | Where-Object { $_ } | Sort-Object -Unique
    if (@($commandTypes).Count -eq 0) {
        $commandTypes = @("application")
    }

    $replaces = @(
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Base -Name "replaces") { $Base.replaces })),
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Overlay -Name "replaces") { $Overlay.replaces }))
    ) | Where-Object { $_ } | Sort-Object -Unique

    $tags = @(
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Base -Name "tags") { $Base.tags })),
        (Get-RegistryStringList -Value $(if (Test-RegistryProperty -Object $Overlay -Name "tags") { $Overlay.tags }))
    ) | Where-Object { $_ } | Sort-Object -Unique

    $posixAnalogue = Get-RegistryString -Object $Overlay -Name "posix_analogue"
    if (-not $posixAnalogue) {
        $posixAnalogue = Get-RegistryString -Object $Base -Name "posix_analogue"
    }

    $notes = Get-RegistryString -Object $Overlay -Name "notes"
    if (-not $notes) {
        $notes = Get-RegistryString -Object $Base -Name "notes"
    }

    $preferred = if ($null -ne $Overlay -and (Test-RegistryProperty -Object $Overlay -Name "preferred")) {
        [bool]$Overlay.preferred
    }
    else {
        Get-RegistryBoolean -Object $Base -Name "preferred" -Default $false
    }

    [pscustomobject]@{
        name = $name
        category = $category
        description = $description
        available_in = @($availableIn)
        command_types = @($commandTypes)
        preferred = $preferred
        replaces = @($replaces)
        posix_analogue = $posixAnalogue
        tags = @($tags)
        notes = $notes
    }
}

function Get-ToolsRegistryEntries {
    $baseEntries = Get-JsonArrayOrEmpty -Path $script:TerminalToolsJsonPath
    $manualEntries = Get-JsonArrayOrEmpty -Path $script:ManualToolsJsonPath
    $merged = @{}

    foreach ($entry in @($baseEntries)) {
        $name = Get-RegistryString -Object $entry -Name "name"
        if ($name) {
            $merged[$name.ToLowerInvariant()] = Merge-RegistryEntry -Base $entry
        }
    }

    foreach ($entry in @($manualEntries)) {
        $name = Get-RegistryString -Object $entry -Name "name"
        if (-not $name) {
            continue
        }

        $key = $name.ToLowerInvariant()
        if ($merged.ContainsKey($key)) {
            $merged[$key] = Merge-RegistryEntry -Base $merged[$key] -Overlay $entry
        }
        else {
            $merged[$key] = Merge-RegistryEntry -Base ([pscustomobject]@{ name = $name }) -Overlay $entry
        }
    }

    @(
        $merged.Values |
            Sort-Object @{ Expression = "category" }, @{ Expression = { -[int][bool]$_.preferred } }, @{ Expression = "name" }
    )
}

function Join-PrettyList {
    param([object[]]$Items)
    (Get-RegistryStringList -Value $Items) -join " · "
}

function Truncate-Text {
    param(
        [AllowNull()][string]$Text,
        [int]$MaxLength = 56
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ""
    }

    $clean = ($Text -replace "\s+", " ").Trim()
    if ($clean.Length -le $MaxLength) {
        return $clean
    }

    $clean.Substring(0, [Math]::Max(0, $MaxLength - 3)) + "..."
}

function Get-ToolsHelpText {
@"
tools
-----
List useful tools from terminal-tools.json and manual-tools.json.

Usage
  tools
  tools -Category data
  tools -Name jq
  tools -Tag json
  tools -PreferredOnly
  tools -Grouped
  tools -Detailed
  tools -Json
  tools -Help

tools-add
---------
Add or update one manual tool entry in manual-tools.json.

Usage
  tools-add jq -Category data -Description "JSON processor"
  tools-add jq -Preferred -PosixAnalogue jq -Tags json,data
  tools-add jq -Replaces jq -Notes "Representative JSON filter"
  tools-add -Help
"@
}

function Show-ToolsRegistry {
    param(
        [string]$Category,
        [string]$Name,
        [string[]]$Tag = @(),
        [switch]$PreferredOnly,
        [switch]$Grouped,
        [switch]$Detailed,
        [switch]$Json,
        [switch]$Help
    )

    if ($Help) {
        Write-Host (Get-ToolsHelpText)
        return
    }

    $data = Get-ToolsRegistryEntries
    if (-not [string]::IsNullOrWhiteSpace($Category)) {
        $data = @($data | Where-Object { $_.category -eq $Category })
    }
    if (-not [string]::IsNullOrWhiteSpace($Name)) {
        $pattern = $Name.ToLowerInvariant()
        $data = @($data | Where-Object { $_.name.ToLowerInvariant() -like "*$pattern*" })
    }

    $normalizedTags = @(Get-RegistryStringList -Value $Tag | ForEach-Object { $_.ToLowerInvariant() })
    if (@($normalizedTags).Count -gt 0) {
        $data = @(
            $data | Where-Object {
                $entryTags = @($_.tags | ForEach-Object { $_.ToLowerInvariant() })
                @($normalizedTags | Where-Object { $entryTags -contains $_ }).Count -gt 0
            }
        )
    }

    if ($PreferredOnly) {
        $data = @($data | Where-Object { $_.preferred })
    }

    if (@($data).Count -eq 0) {
        Write-Warning "No tools matched the current filters."
        return
    }

    if ($Json) {
        $data | ConvertTo-Json -Depth 6
        return
    }

    if ($Grouped) {
        foreach ($group in ($data | Group-Object category)) {
            Write-Host ""
            Write-Host "[$($group.Name)]"
            foreach ($tool in ($group.Group | Sort-Object @{ Expression = { -[int][bool]$_.preferred } }, name)) {
                $prefix = if ($tool.preferred) { "★" } else { " " }
                $nameText = $tool.name.PadRight(14)
                $desc = Truncate-Text -Text $tool.description -MaxLength 68
                Write-Host "  $prefix $nameText $desc"
            }
        }
        return
    }

    if ($Detailed) {
        foreach ($tool in $data) {
            $title = if ($tool.preferred) { "★ $($tool.name)" } else { $tool.name }
            Write-Host $title
            Write-Host "  category : $($tool.category)"
            Write-Host "  shells   : $(Join-PrettyList $tool.available_in)"
            Write-Host "  types    : $(Join-PrettyList $tool.command_types)"
            if (@($tool.tags).Count -gt 0) {
                Write-Host "  tags     : $(Join-PrettyList $tool.tags)"
            }
            if (@($tool.replaces).Count -gt 0) {
                Write-Host "  replaces : $(Join-PrettyList $tool.replaces)"
            }
            if ($tool.posix_analogue) {
                Write-Host "  posix    : $($tool.posix_analogue)"
            }
            if ($tool.notes) {
                Write-Host "  notes    : $($tool.notes)"
            }
            Write-Host "  desc     : $($tool.description)"
            Write-Host ""
        }
        return
    }

    $data |
        ForEach-Object {
            [pscustomobject]@{
                "  Name" = if ($_.preferred) { "★ $($_.name)" } else { "  $($_.name)" }
                Category = $_.category
                Shells = Join-PrettyList $_.available_in
                Types = Join-PrettyList $_.command_types
                Description = Truncate-Text -Text $_.description -MaxLength 56
            }
        } |
        Format-Table -AutoSize "  Name", Category, Shells, Types, Description
}

function Add-ToolsRegistryEntry {
    param(
        [string]$Name,
        [string]$Category,
        [string]$Description,
        [string[]]$AvailableIn,
        [string[]]$CommandTypes,
        [switch]$Preferred,
        [string[]]$Replaces,
        [string]$PosixAnalogue,
        [string[]]$Tags,
        [string]$Notes,
        [switch]$Help
    )

    if ($Help -or [string]::IsNullOrWhiteSpace($Name)) {
        Write-Host (Get-ToolsHelpText)
        return
    }

    if (-not (Test-Path -LiteralPath $script:TerminalToolsHome)) {
        New-Item -ItemType Directory -Force -Path $script:TerminalToolsHome | Out-Null
    }

    $existingManual = Get-JsonArrayOrEmpty -Path $script:ManualToolsJsonPath
    $existingMerged = Get-ToolsRegistryEntries | Where-Object { $_.name -eq $Name } | Select-Object -First 1

    if (-not $PSBoundParameters.ContainsKey("AvailableIn") -and $existingMerged) {
        $AvailableIn = @($existingMerged.available_in)
    }
    if (-not $PSBoundParameters.ContainsKey("AvailableIn") -or @($AvailableIn).Count -eq 0) {
        $AvailableIn = @("powershell", "pwsh")
    }

    if (-not $PSBoundParameters.ContainsKey("CommandTypes") -or @($CommandTypes).Count -eq 0) {
        if ($existingMerged -and @($existingMerged.command_types).Count -gt 0) {
            $CommandTypes = @($existingMerged.command_types)
        }
        else {
            $cmd = Get-Command -Name $Name -ErrorAction SilentlyContinue
            if ($cmd) {
                $CommandTypes = @($cmd.CommandType.ToString().ToLowerInvariant())
            }
            else {
                $CommandTypes = @("application")
            }
        }
    }

    $entry = [pscustomobject]@{
        name = $Name
        category = if ($PSBoundParameters.ContainsKey("Category")) { $Category } elseif ($existingMerged) { $existingMerged.category } else { "custom" }
        description = if ($PSBoundParameters.ContainsKey("Description")) { $Description } elseif ($existingMerged) { $existingMerged.description } else { "Manually added tool" }
        available_in = @(Get-RegistryStringList -Value $AvailableIn)
        command_types = @(Get-RegistryStringList -Value $CommandTypes)
        preferred = if ($PSBoundParameters.ContainsKey("Preferred")) { [bool]$Preferred.IsPresent } elseif ($existingMerged) { [bool]$existingMerged.preferred } else { $false }
        replaces = if ($PSBoundParameters.ContainsKey("Replaces")) { @(Get-RegistryStringList -Value $Replaces) } elseif ($existingMerged) { @($existingMerged.replaces) } else { @() }
        posix_analogue = if ($PSBoundParameters.ContainsKey("PosixAnalogue")) { $PosixAnalogue } elseif ($existingMerged) { $existingMerged.posix_analogue } else { $null }
        tags = if ($PSBoundParameters.ContainsKey("Tags")) { @(Get-RegistryStringList -Value $Tags) } elseif ($existingMerged) { @($existingMerged.tags) } else { @() }
        notes = if ($PSBoundParameters.ContainsKey("Notes")) { $Notes } elseif ($existingMerged) { $existingMerged.notes } else { $null }
    }

    $updated = @(
        $existingManual | Where-Object {
            (Get-RegistryString -Object $_ -Name "name") -and
            (Get-RegistryString -Object $_ -Name "name").ToLowerInvariant() -ne $Name.ToLowerInvariant()
        }
    ) + @($entry)

    $updated | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $script:ManualToolsJsonPath -Encoding UTF8
    Write-Host "Updated manual tool entry:"
    Write-Host "  $script:ManualToolsJsonPath"
}

Set-Alias tools Show-ToolsRegistry
Set-Alias tools-add Add-ToolsRegistryEntry

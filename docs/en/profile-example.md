# Profile Example

This page shows what a practical `profile.d/` setup looks like after the bootstrap scaffold has been customized. The bootstrap creates the minimum; this example shows a fuller working profile.

## File Layout

```
Documents/PowerShell/
├── Microsoft.PowerShell_profile.ps1    # loader
├── profile.d/
│   ├── 00-core.ps1                     # environment normalization
│   ├── 10-modules.ps1                  # interactive module imports
│   ├── 20-interactive.ps1              # PSReadLine settings
│   ├── 22-local-cli-paths.ps1          # extra PATH entries
│   ├── 25-tool-integrations.ps1        # direnv, fzf, etc.
│   ├── 30-aliases.ps1                  # POSIX-like command mappings
│   ├── 32-ls-eza.ps1                   # eza-based listing aliases
│   ├── 33-cd-zoxide.ps1               # zoxide-aware cd wrapper
│   ├── 35-terminal-tools.ps1           # tool registry
│   └── 90-local.ps1                    # machine-specific overrides
└── AgentName.Exec_profile.ps1          # agent-safe subset
```

## Example: `00-core.ps1`

```powershell
# XDG directory normalization
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path $HOME '.config' }
if (-not $env:XDG_CACHE_HOME)  { $env:XDG_CACHE_HOME  = Join-Path $HOME '.cache' }
if (-not $env:XDG_DATA_HOME)   { $env:XDG_DATA_HOME   = Join-Path $HOME '.local\share' }

# Safe PATH helper
function Add-PathIfExists {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $parts = @($env:PATH -split ';' | Where-Object { $_ })
    if ($parts -contains $Path) { return }
    $env:PATH = ($parts + $Path) -join ';'
}

# Safe module import helper
function Import-OptionalModule {
    param([string]$Name)
    try { Import-Module $Name -ErrorAction Stop }
    catch { Write-Verbose "Optional module not available: $Name" }
}

# which equivalent
function which { param([string]$Name) (Get-Command $Name -ErrorAction SilentlyContinue).Source }
```

## Example: `30-aliases.ps1`

```powershell
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat -Option AllScope
}
if (Get-Command fd -ErrorAction SilentlyContinue) {
    Set-Alias find fd -Option AllScope
}
if (Get-Command rg -ErrorAction SilentlyContinue) {
    Set-Alias grep rg -Option AllScope
}
```

## Example: `32-ls-eza.ps1`

```powershell
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls  { eza --icons --group-directories-first @args }
    function la  { eza --icons --group-directories-first -a @args }
    function ll  { eza --icons --group-directories-first -l @args }
    function lla { eza --icons --group-directories-first -la @args }
    function lt  { eza --icons --group-directories-first -l --sort=modified @args }
    function tree { eza --icons --tree @args }
}
```

## Example: `33-cd-zoxide.ps1`

```powershell
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })

    function cd {
        param([string]$Path)
        if (-not $Path -or $Path -eq '~') { Set-Location $HOME; return }
        if ($Path -eq '-') { Set-Location -; return }
        if ($Path -eq '..') { Set-Location ..; return }
        if (Test-Path -LiteralPath $Path) { Set-Location $Path; return }
        # Fall back to zoxide for fuzzy matching
        z $Path
    }
}
```

## Example: Agent Exec Profile

A separate file (e.g., `AgentName.Exec_profile.ps1`) loads only the safe subset:

```powershell
$profileDir = Join-Path $HOME 'Documents\PowerShell\profile.d'
$safeModules = @(
    '00-core.ps1',
    '22-local-cli-paths.ps1',
    '25-tool-integrations.ps1',
    '30-aliases.ps1',
    '32-ls-eza.ps1',
    '35-terminal-tools.ps1'
)

foreach ($name in $safeModules) {
    $path = Join-Path $profileDir $name
    if (Test-Path -LiteralPath $path) { . $path }
}
```

What it excludes:

- `10-modules.ps1` — prompt themes, `posh-git`, `Terminal-Icons`
- `20-interactive.ps1` — `PSReadLine` keybindings and prediction
- `33-cd-zoxide.ps1` — interactive fuzzy matching (optional; include if the agent benefits from it)
- `90-local.ps1` — machine-specific overrides that may not be safe for automation

## Key Patterns

1. **Every file guards its own dependencies** — check for the command before aliasing or integrating
2. **Numbered prefixes control load order** — not alphabetical, but intentional priority
3. **Agent profiles are strict subsets** — never a superset of the interactive profile
4. **Fallbacks are silent** — missing tools cause a quiet skip, not a noisy error

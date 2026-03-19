# What Changes After Applying This Environment

This page summarizes the concrete behavior changes that happen when you apply the SuperPowerShell baseline. Read this before running the bootstrap so you know what you are opting into.

## Commands That Change Behavior

After applying the recommended aliases, the following familiar command names no longer behave like stock PowerShell:

| Command | Before (stock PowerShell) | After (this environment) |
| --- | --- | --- |
| `cat` | `Get-Content` | `bat` (syntax-highlighted file viewer) |
| `ls` | `Get-ChildItem` | `eza` (modern directory listing with icons) |
| `find` | not available or ambiguous | `fd` (recursive file discovery) |
| `grep` | not available | `rg` (ripgrep, fast text search) |
| `cd` | `Set-Location` | `zoxide`-aware wrapper (learns frequent directories) |
| `curl` | `Invoke-WebRequest` (built-in alias) | unchanged, but use `curl.exe` for the real binary |

## What Gets Added to PATH

The bootstrap may add user-level tool directories to `PATH`:

- npm global prefix (default `~\.local\npm-tools`) for agent extras
- Python user scripts directory
- Any paths listed in `profile.d/` path files

## Profile Loading Changes

- Your PowerShell profile gets a `profile.d/` loader appended (if not already present)
- Startup logic is split into numbered files loaded in order
- Interactive-only modules (prompt themes, `PSReadLine` settings) stay out of agent exec profiles

## Environment Variables

The `00-core.ps1` fragment sets XDG base directories if not already present:

- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_CACHE_HOME` → `~/.cache`
- `XDG_DATA_HOME` → `~/.local/share`

These help Unix-oriented tools behave consistently on Windows.

## What Does NOT Change

- No system-wide policy is modified
- No existing tools are uninstalled
- `powershell` (5.1) is not removed or altered
- You can still use the original commands by their full names (e.g., `Get-ChildItem`, `Get-Content`)
- WSL is not affected

## Reverting

To revert:

1. Remove the `profile.d/` loader from your PowerShell profile
2. Delete the `profile.d/` directory
3. Optionally uninstall tools via `winget uninstall`

No changes are permanent or irreversible.

---
name: "winget-essentials"
description: "Use when an agent needs to install, update, search, or manage software packages on Windows using winget — the native Windows package manager."
---

# Winget Essentials

English summary:
Use this skill when an agent needs to manage software packages on Windows using winget, the built-in package manager.

한국어 요약:
이 스킬은 에이전트가 Windows의 기본 패키지 매니저인 winget을 사용하여 소프트웨어를 설치·업데이트·관리할 때 사용합니다.

## Use This Skill When

- installing a new tool or application
- checking if something is already installed
- updating packages to latest versions
- the agent would use `apt install` or `brew install` on other platforms
- listing installed software for inventory

## Core Rules

1. `winget` is the native Windows package manager (ships with Windows 10 1709+ and Windows 11).
2. Always use `--accept-package-agreements --accept-source-agreements` in non-interactive (agent) contexts to avoid blocking prompts.
3. Use `--id` for precise package matching. Display names can be ambiguous.
4. Prefer `--source winget` to ensure you're pulling from the community repository, not msstore.
5. Some installs require **admin elevation**. Check before running, or use `--scope user` when possible.

## Patterns

### Search for a package
```powershell
# Search by keyword:
winget search ripgrep

# Search with source specified:
winget search --source winget "Visual Studio Code"
```

### Install a package
```powershell
# Basic install (may prompt):
winget install BurntSushi.ripgrep.MSVC

# Non-interactive install (agent-safe):
winget install --id BurntSushi.ripgrep.MSVC --source winget `
    --accept-package-agreements --accept-source-agreements

# Install for current user only (no admin needed):
winget install --id Mozilla.Firefox --scope user `
    --accept-package-agreements --accept-source-agreements

# Silent install (no installer UI):
winget install --id Git.Git --silent `
    --accept-package-agreements --accept-source-agreements
```

### Check if something is installed
```powershell
# List installed packages matching a name:
winget list --name "ripgrep"

# Check by exact ID:
winget list --id BurntSushi.ripgrep.MSVC

# If exit code is 0 and output contains the package, it's installed.
```

### Update packages
```powershell
# Check for available updates:
winget upgrade

# Update a specific package:
winget upgrade --id Microsoft.PowerShell --source winget `
    --accept-package-agreements --accept-source-agreements

# Update all packages (use with caution):
winget upgrade --all --accept-package-agreements --accept-source-agreements
```

### Show package details
```powershell
# View details before installing:
winget show --id BurntSushi.ripgrep.MSVC --source winget
```

### Uninstall a package
```powershell
winget uninstall --id BurntSushi.ripgrep.MSVC
```

### Export / Import (reproducible environments)
```powershell
# Export installed packages to JSON:
winget export -o packages.json

# Import on another machine:
winget import -i packages.json `
    --accept-package-agreements --accept-source-agreements
```

## Common Package IDs

| Tool | Package ID |
|---|---|
| PowerShell 7 | `Microsoft.PowerShell` |
| Git | `Git.Git` |
| VS Code | `Microsoft.VisualStudioCode` |
| Node.js LTS | `OpenJS.NodeJS.LTS` |
| Python | `Python.Python.3.12` |
| ripgrep | `BurntSushi.ripgrep.MSVC` |
| fd | `sharkdp.fd` |
| fzf | `junegunn.fzf` |
| jq | `jqlang.jq` |
| 7-Zip | `7zip.7zip` |
| Windows Terminal | `Microsoft.WindowsTerminal` |

## Comparison with Other Package Managers

| Task | winget | apt (Ubuntu) | brew (macOS) |
|---|---|---|---|
| Search | `winget search X` | `apt search X` | `brew search X` |
| Install | `winget install --id X` | `apt install X` | `brew install X` |
| Update one | `winget upgrade --id X` | `apt install --only-upgrade X` | `brew upgrade X` |
| Update all | `winget upgrade --all` | `apt upgrade` | `brew upgrade` |
| List installed | `winget list` | `apt list --installed` | `brew list` |
| Remove | `winget uninstall --id X` | `apt remove X` | `brew uninstall X` |
| Show info | `winget show --id X` | `apt show X` | `brew info X` |

## Common Pitfalls

- **Ambiguous names**: `winget install python` may match multiple packages. Always use `--id` for precision.
- **Source confusion**: `--source msstore` pulls from Microsoft Store, which may have different versions. Use `--source winget` for community packages.
- **PATH not updated**: Some installs add to PATH but the current session doesn't see it. Start a new session or refresh: `$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH", "User")`.
- **Admin required**: System-wide installs often need elevation. Use `--scope user` to install per-user when possible.
- **Interactive prompts**: Installers may pop up GUI windows. Use `--silent` to suppress, though not all installers respect it.
- **Version pinning**: `winget install --id X --version 1.2.3` pins a specific version. Without it, you get latest.

## Output From This Skill

When using this skill, state:

- what package you are installing and its exact ID
- whether admin elevation is needed
- whether `--scope user` is sufficient
- whether PATH needs refreshing after install

# Installation Guide

This project treats installation in two layers:

1. **Core shell baseline** - tools that materially change day-to-day shell ergonomics
2. **Agent extras** - tools that help local coding agents read, parse, transform, or summarize information

## Human Quick Start

1. Install **PowerShell 7.5+**
2. Preview the all-in-one bootstrap
3. Apply only the layers you actually want
4. Add optional agent extras
5. Read the security notes before sourcing profile fragments from the internet

## One-Shot Bootstrap

If you want a guided starting point instead of running each script by hand, start here:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\bootstrap-all.ps1 -WhatIf
```

Example with the optional tools registry and agent extras:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\bootstrap-all.ps1 -Apply -AcceptAgreements -InstallToolsRegistry -IncludeAgentExtras
```

If you want to install the repo's example skills for Codex too:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\bootstrap-all.ps1 -Apply -AcceptAgreements -InstallToolsRegistry -InstallSkills -SkillPreset codex
```

## Recommended Core Baseline

If `pwsh` is not installed yet, install `Microsoft.PowerShell` first from Windows PowerShell, Windows Terminal, or the winget UI, then rerun the script below.

Preview first:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-core-tools-winget.ps1 -WhatIf
```

Apply after reviewing the output:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-core-tools-winget.ps1 -Apply -AcceptAgreements
```

This script installs the baseline stack through `winget`:

- `Microsoft.PowerShell`
- `BurntSushi.ripgrep.MSVC`
- `sharkdp.fd`
- `jqlang.jq`
- `MikeFarah.yq`
- `sharkdp.bat`
- `junegunn.fzf`
- `eza-community.eza`
- `ajeetdsouza.zoxide`
- `astral-sh.uv`
- `Casey.Just`
- `direnv.direnv`
- `ducaale.xh`
- `JohnMacFarlane.Pandoc`
- `Wilfred.difftastic`
- `sharkdp.hyperfine`
- `dandavison.delta`

## Agent Extras

Preview first:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-agent-extras.ps1 -WhatIf
```

Apply after reviewing the commands:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-agent-extras.ps1 -Apply
```

This script prefers more isolated defaults:

- `defuddle` via a user-local npm prefix
- `fx` via a user-local npm prefix
- `jc` via `uv tool`, `pipx`, or `pip --user`, depending on what is available

## Additional Bootstrap Scripts

- `bootstrap-profile.ps1` - create a modular `profile.d` scaffold and a loader
- `bootstrap-tools-inventory.ps1` - generate a starter `terminal-tools.json` for the current machine
- `install-skills.ps1` - copy the repo's example skills into a target skill directory

## Why Two Layers?

The core layer should stay predictable and broadly useful.

The extra layer is valuable, but it assumes:

- `npm` is available
- a Python tool installer such as `uv`, `pipx`, or `pip --user` is available
- you actually want agent-oriented parsing and extraction helpers

## PowerShell Compatibility

- Recommended shell: `pwsh` 7.5+
- Compatibility shell: Windows PowerShell 5.1
- Do not expect equal behavior across both shells once aliases, wrappers, and profile modules are involved

## Prerequisites

- `winget` for the baseline install script
- `npm` for JavaScript-based extras
- `python` plus `uv`, `pipx`, or `pip` for Python-based extras
- administrative rights only when your package manager or local policy requires them

## Safety Notes

- Read the scripts before running them.
- Prefer preview mode first.
- Avoid treating `ExecutionPolicy Bypass` as a normal default for local setup.
- If you publish your own variant, document what gets installed and where it lands on `PATH`.

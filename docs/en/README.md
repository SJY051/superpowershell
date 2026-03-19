# SuperPowerShell Docs (English)

## Overview

This documentation explains how to build an agent-friendly Windows PowerShell environment that feels calmer, more Unix-like, and more predictable for both humans and local coding agents.

## Documents

- [tools.md](tools.md) - core and extended tool catalog, installation methods, POSIX analogues, and practical value
- [install.md](install.md) - practical installation path for humans and agents
- [agent-quickstart.md](agent-quickstart.md) - minimal setup path for local agents
- [shell-matrix.md](shell-matrix.md) - what shells exist and how they differ
- [profile-architecture.md](profile-architecture.md) - modular PowerShell profile structure
- [aliases.md](aliases.md) - recommended aliases and command replacements
- [scripts.md](scripts.md) - useful PowerShell helper scripts, profile patterns, and agent-oriented shell helpers
- [skills.md](skills.md) - additional skill ideas worth using in Windows-focused agent workflows
- [troubleshooting.md](troubleshooting.md) - common problems and why they happen
- [../../skills/README.md](../../skills/README.md) - example reusable skills shipped with this repository
- [../../CONTRIBUTING.md](../../CONTRIBUTING.md) - contribution rules for public-facing docs and scripts
- [../../SECURITY.md](../../SECURITY.md) - release and operational safety notes

## Scope

This repo assumes:

- Windows as the main host OS
- PowerShell 7.5+ as the primary shell
- local coding agents
- a preference for structured outputs, reproducible shell behavior, and low startup noise

# PowerShell Scripts and Profile Patterns

This guide recommends a modular PowerShell profile with agent-safe and human-friendly layers separated.

## Recommended Pattern

Split the profile into small role-based files:

- `00-core.ps1` for safe shared helpers
- path/bootstrap files for local CLI availability
- integration files for tools such as `direnv`, `PSFzf`, or directory-jump helpers
- alias files for representative command mappings
- listing/navigation files for `eza` and `zoxide`
- tool-registry helpers for inventory export or preferred-command lookup
- legacy functions in a separate block, not mixed into core startup

## Why This Matters

A giant monolithic profile is hard to debug and easy to break. A modular profile:

- reduces startup noise
- makes failures easier to localize
- lets agents load only the safe subset they need
- avoids loading decorative modules in non-interactive contexts

## Agent-Oriented Patterns Worth Documenting

### 1. Low-noise exec profile

Use a separate lightweight profile for agents that need:

- no decorative prompt theme
- no interactive-only modules
- only stable path setup, aliases, tool integrations, and helper functions

### 2. Tool registry helpers

Expose some machine-readable way to inspect preferred tools, shell coverage, or supported aliases so agents do not have to guess command names.

### 3. XDG-style directory normalization

On Windows, setting `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` helps some Unix-oriented tools behave more consistently.

### 4. Explicit fallback behavior

If an optional integration is missing, prefer a calm fallback over a noisy startup failure.

## Repo Scripts

- [../../scripts/install-core-tools-winget.ps1](../../scripts/install-core-tools-winget.ps1) - preview or install the recommended baseline with `winget`
- [../../scripts/install-agent-extras.ps1](../../scripts/install-agent-extras.ps1) - preview or install optional agent-oriented extras with more isolated defaults
- [../../scripts/bootstrap-all.ps1](../../scripts/bootstrap-all.ps1) - orchestrate baseline install, profile setup, inventory bootstrap, optional feature install, and optional skill install
- [../../scripts/bootstrap-profile.ps1](../../scripts/bootstrap-profile.ps1) - create a modular `profile.d` scaffold and loader
- [../../scripts/bootstrap-tools-inventory.ps1](../../scripts/bootstrap-tools-inventory.ps1) - generate a starter `terminal-tools.json` from currently installed commands
- [../../scripts/install-skills.ps1](../../scripts/install-skills.ps1) - install shipped example skills into a target skill directory
- [../../scripts/export-preferred-tools.ps1](../../scripts/export-preferred-tools.ps1) - emit the preferred tool subset as JSON from a configurable inventory directory
- [../../scripts/get-shell-matrix.ps1](../../scripts/get-shell-matrix.ps1) - emit the current shell coverage snapshot as JSON, with host-specific data omitted by default
- [../../features/tools-registry/README.md](../../features/tools-registry/README.md) - optional installable feature that adds `tools` and `tools-add`

## Public-Release Note

If you publish your own shell helpers, document clearly which ones are examples, which ones are included in the repository, and which ones are private local extensions.

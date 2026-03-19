# Agent Quick Start

This page is the shortest practical path for a local coding agent that needs a calm Windows shell.

## Goal

Give the agent:

- a predictable primary shell,
- low startup noise,
- a small set of representative commands,
- enough structured tools to inspect files, data, and HTTP responses without guesswork.

## Recommended Minimum

1. Install `pwsh` 7.5 or newer.
2. Start with the preview-first bootstrap flow from [install.md](install.md).
3. Add a low-noise execution profile for agent use.
4. Expose a small tool registry such as `tools`.
5. Prefer representative commands over ambiguous overlap.

## Representative Command Set

- text search: `rg`
- file discovery: `fd`
- file viewing: `bat`
- JSON processing: `jq`
- YAML processing: `yq`
- directory listing: `eza`
- directory jumping: `zoxide`
- task running: `just`
- HTTP baseline: `curl`
- readable HTTP companion: `xh`

## Good Agent Defaults

- use `pwsh -NoLogo -NoProfile` when you need a clean baseline
- use a separate execution profile when you need a stable but richer environment
- keep aliases documented
- keep structured output tools easy to find
- prefer WSL only when real POSIX shell semantics matter

## Avoid

- giant monolithic PowerShell profiles
- decorative startup noise in automation contexts
- multiple overlapping defaults with no clearly preferred command
- hidden wrappers that change command behavior without documentation

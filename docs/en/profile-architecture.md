# Profile Architecture

This guide recommends a modular `profile.d` layout instead of one giant PowerShell profile file.

## Main Idea

Keep startup logic split by responsibility:

- core helpers
- path bootstrap
- tool integrations
- aliases
- navigation/listing
- tool registry
- legacy functions

## Example File Layout

| File | Purpose |
| --- | --- |
| `00-core.ps1` | safe shared helpers, environment normalization, quiet defaults |
| `10-paths.ps1` | path additions for user-local CLI tools |
| `20-integrations.ps1` | optional tool integrations such as `direnv`, `PSFzf`, or `zoxide` |
| `30-aliases.ps1` | representative command aliases like `cat`, `find`, `grep` |
| `40-navigation.ps1` | listing and directory-jump behavior |
| `50-registry.ps1` | tool inventory helpers or preferred-command export |
| `90-local.ps1` | machine-specific or user-specific local overrides |

These names are illustrative, not a required standard.

## Agent-Safe Variant

A separate low-noise exec profile is recommended for agents so they do not load decorative or interaction-heavy modules by default.

## Why It Works

This structure makes it easier to:

- isolate startup failures
- explain behavior changes
- load only safe subsets
- keep old compatibility helpers from polluting the main startup path

## Public Documentation Rule

If a profile module is not included in the repository, document it as an example pattern rather than as a shipped file.

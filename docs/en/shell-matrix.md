# Shell Matrix

This environment is not a single-shell story.

## Current Coverage Snapshot

| Shell | Role | Version | Notes |
| --- | --- | --- | --- |
| `pwsh` | primary interactive and agent shell | 7.5.x or newer | richest profile behavior and main target |
| `powershell` | compatibility shell | 5.1 | kept for compatibility, not the main UX target |
| `wsl:sh` | partial Unix fallback | version unknown in current snapshot | useful when true POSIX shell semantics matter |

## Practical Guidance

- Use `pwsh` for day-to-day work.
- Use Windows PowerShell 5.1 only when older modules or compatibility constraints require it.
- Use WSL when shell semantics matter more than Windows integration.

## Why This Matters For Agents

An agent should not assume every shell in the environment behaves the same way.

- aliases differ
- profile loading differs
- module support differs
- startup side effects differ

Document the differences explicitly rather than pretending parity exists.

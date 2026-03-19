# Security Notes

This repository contains documentation and helper scripts for building an agent-friendly Windows PowerShell environment.

## Scope

- The repository is designed for trusted local development environments.
- It is not a sandboxing framework.
- It does not claim to make arbitrary shell execution safe for untrusted code.

## Before Running Scripts

- Read each script before running it.
- Prefer the provided `-WhatIf` mode where available.
- Verify package manager IDs before installing globally.
- Review profile fragments before sourcing them into an interactive shell.

## Package Manager Caution

- `winget`, `npm`, and `pip` all modify the local machine or user profile in different ways.
- Global `npm` installs and user-level `pip` installs can change command resolution for future shells.
- Prefer user-level installs unless a system-wide install is truly required.

## Profile Safety

- Keep interactive prompt themes and decorative modules out of agent execution profiles.
- Avoid profile startup logic that downloads remote code, mutates policy, or depends on brittle environment assumptions.
- Treat aliases and wrappers as behavior changes. Document them clearly so users and agents know when `cat`, `ls`, `find`, or `cd` no longer behave like stock PowerShell.

## Agent-Specific Caution

- Prefer low-noise, bounded execution profiles for agents.
- Keep tool-discovery commands explicit so agents do not guess command names.
- Do not expose broad automation helpers without documenting their scope and side effects.
- If you add a custom command runner, treat it as a local execution primitive, not as a trust boundary.

## Public Release Hygiene

- Do not publish absolute local paths in docs.
- Do not publish private machine names, internal repo names, or hidden toolchain assumptions as if they were universal requirements.
- Do not commit local caches, generated shell state, package-manager credentials, or environment-specific secrets.

# Troubleshooting

## The shell is noisy on startup

Common causes:

- legacy prompt modules
- interactive-only settings loading in non-interactive shells
- broken theme caches
- integrations that assume Unix-like config directories

## A tool is installed but not found

Check:

- whether the tool landed in a user-level path not yet added to `PATH`
- whether it only appears in a login shell
- whether the package manager installed a shim into a nonstandard location

## The command behaves differently from stock PowerShell

That may be intentional.

Look for:

- aliases such as `cat -> bat`
- wrappers such as `cd` with `zoxide`
- listing replacements such as `ls -> eza`

## A feature silently does not work

Some integrations fail quietly on purpose to keep startup calm.

Examples:

- missing `direnv`
- missing `PSFzf`
- missing `eza`

In those cases, the shell may fall back instead of crashing.

## A legacy helper still exists

Document it clearly as compatibility-only.

Example:

- once a simpler or better-documented path exists, do not keep the legacy helper as the default execution route

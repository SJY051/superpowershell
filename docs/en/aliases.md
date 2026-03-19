# Recommended Aliases and Command Mappings

These aliases are not about novelty. They are here to reduce ambiguity and make a Windows PowerShell environment easier for Unix-leaning humans and agents to use.

## Core Mappings

| Alias or behavior | Target | Why |
| --- | --- | --- |
| `cat` | `bat` | Better file viewing with syntax highlighting and plain output mode |
| `find` | `fd` | A friendlier replacement for recursive file search |
| `grep` | `rg` | Faster and more reliable text search in this environment |
| `ls` | `eza` | Better default directory listing |
| `cd` | `zoxide`-aware wrapper | Smarter directory jumping while preserving explicit paths |

## Important Principle

Do not remove alternatives just because a default exists.

- Keep `curl`, `xh`, and `http` if they solve slightly different use cases
- Keep `eza` and `lsd` if both are useful, but clearly mark one as the default
- Keep `just`, `make`, and `task` when projects require them, but choose one representative default

## Human + Agent Benefit

These mappings help both people and agents because they:

- reduce guesswork
- make role boundaries clearer
- reduce accidental use of weaker defaults
- surface a preferred command without hiding alternatives

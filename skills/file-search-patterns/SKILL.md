---
name: "file-search-patterns"
description: "Use when an agent needs to search for files or text content on Windows, choosing the best tool between PowerShell-native cmdlets and installed CLI tools like ripgrep."
---

# File Search Patterns

English summary:
Use this skill when an agent needs to find files or search text content on Windows, preferring the best available tool.

한국어 요약:
이 스킬은 에이전트가 Windows에서 파일을 찾거나 텍스트를 검색할 때, 사용 가능한 최적의 도구를 선택하도록 돕습니다.

## Use This Skill When

- searching for files by name or pattern
- searching for text content inside files (grep-like)
- the agent is tempted to use `find`, `grep`, or other Unix commands directly
- the task requires recursive directory traversal with filtering

## Core Rules

1. **If a better CLI tool is installed, prefer it.** `rg` (ripgrep), `fd`, `fzf` are faster and more ergonomic than PowerShell-native equivalents for most search tasks.
2. If no specialized tool is available, use `Get-ChildItem` for file search and `Select-String` for text search.
3. **Never use bare `find` or `grep` on Windows.** `find` is a legacy Windows command (not GNU find). `grep` may be aliased or absent. Check the tool registry first.
4. Use the tool registry (`tools-registry-first` skill) to discover what search tools are available before picking one.

## Tool Preference Order

### File search (find files by name/pattern)

| Priority | Tool | Example | Notes |
|---|---|---|---|
| 1 | `fd` | `fd "\.rs$" src/` | Fast, intuitive syntax, respects .gitignore |
| 2 | `rg --files` | `rg --files -g "*.rs" src/` | ripgrep can list files too |
| 3 | `Get-ChildItem` | `Get-ChildItem -Path src -Recurse -Filter *.rs` | Always available, returns objects |

### Content search (find text inside files)

| Priority | Tool | Example | Notes |
|---|---|---|---|
| 1 | `rg` | `rg "TODO" --type rust` | Fastest, respects .gitignore, regex |
| 2 | `Select-String` | `Get-ChildItem -Recurse -Filter *.rs \| Select-String "TODO"` | Always available, returns match objects |

## Patterns

### ripgrep (if installed)
```powershell
# Search for pattern in current directory:
rg "function\s+main"

# Search specific file type:
rg "TODO" --type py

# Search with context lines:
rg "error" -C 3

# List files only (no content):
rg "pattern" --files-with-matches

# Case-insensitive:
rg -i "config"
```

### fd (if installed)
```powershell
# Find files by name pattern:
fd "config" --type f

# Find with extension:
fd --extension json

# Find directories only:
fd --type d "src"

# Find and execute command on results:
fd --extension log --exec Remove-Item
```

### PowerShell-native fallback
```powershell
# Find files by name pattern:
Get-ChildItem -Path . -Recurse -Filter "*.config" |
    Select-Object FullName

# Find files modified in last 24 hours:
Get-ChildItem -Recurse |
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-1) }

# Search text in files:
Get-ChildItem -Recurse -Filter "*.ps1" |
    Select-String -Pattern "function\s+Get-" |
    Select-Object Path, LineNumber, Line

# Combined: find files containing pattern:
Get-ChildItem -Recurse -Filter "*.json" |
    Select-String -Pattern '"version"' -List |
    Select-Object Path
```

## Common Pitfalls

- **`find` is NOT GNU find on Windows.** It's a legacy command that searches for text strings in files. Completely different from Unix `find`.
- **`grep` may be absent or aliased.** Don't assume it exists. Check with `Get-Command grep -ErrorAction SilentlyContinue` first.
- **`Select-String` returns `MatchInfo` objects, not plain text.** This is actually an advantage — you get `.Path`, `.LineNumber`, `.Line`, `.Matches` properties.
- **`Get-ChildItem -Recurse` without `-Filter` is slow on large trees.** Always use `-Filter` for the file system provider, or add `-Include` / `-Exclude` to narrow results.
- **Hidden and system files**: `Get-ChildItem` skips hidden files by default. Add `-Force` to include them. `rg` and `fd` respect `.gitignore` by default — add `--no-ignore` to override.

## Output From This Skill

When using this skill, state:

- which search tool you are using and why
- whether better tools (rg, fd) are available
- what pattern and scope you are searching
- whether .gitignore / hidden files affect the results

---
name: "windows-path-handling"
description: "Use when an agent constructs, joins, or resolves file paths in Windows to avoid backslash escaping issues, broken joins, and spaces-in-path bugs."
---

# Windows Path Handling

English summary:
Use this skill when an agent works with file paths in Windows and needs to avoid common path construction mistakes.

한국어 요약:
이 스킬은 에이전트가 Windows에서 파일 경로를 다룰 때, 흔한 경로 구성 오류를 방지하도록 돕습니다.

## Use This Skill When

- constructing file paths in PowerShell scripts or commands
- passing paths between PowerShell and native executables
- handling paths that may contain spaces, special characters, or non-ASCII characters
- resolving relative paths or working with UNC paths

## Core Rules

1. **Use forward slashes (`/`) as the default.** PowerShell resolves them correctly, and they avoid backslash escape collisions in strings, regex, and JSON.
2. Use `Join-Path` for combining path segments instead of string concatenation.
3. Always quote paths that may contain spaces — use double quotes in PowerShell.
4. Use `Resolve-Path` or `Convert-Path` to normalize paths before passing to external tools.
5. Be aware of the 260-character path limit on older Windows APIs. Use `\\?\` prefix or enable long paths via Group Policy if needed.

## Patterns

### Forward slashes everywhere
```powershell
# Good — no escape collisions, works everywhere in PowerShell:
$path = "C:/Users/User/Documents/project/src"

# Risky — backslashes can cause issues in double-quoted strings:
$path = "C:\Users\User\Documents\project\src"
# In this case it works, but inside regex or JSON it breaks.
```

### Joining paths safely
```powershell
# Good:
$full = Join-Path $rootDir "src/components"

# Bad — breaks if $rootDir has trailing slash or doesn't:
$full = "$rootDir\src\components"
```

### Paths with spaces
```powershell
# Always quote when passing to native executables:
& "C:/Program Files/Git/bin/git.exe" status

# Or use the call operator with a variable:
$git = "C:/Program Files/Git/bin/git.exe"
& $git status
```

### Normalizing paths
```powershell
# Resolve to absolute path:
$absolute = Resolve-Path "./relative/path"

# Convert PSDrive paths to filesystem paths (useful for external tools):
$fsPath = Convert-Path "Temp:/myfile.txt"
```

### UNC paths
```powershell
# UNC paths work with forward slashes too:
$share = "//server/share/folder"

# But some legacy tools require backslashes for UNC. Convert when needed:
$legacyPath = $share -replace '/', '\'
```

## Common Pitfalls

- **Backslash + special characters**: `"C:\new\file"` is actually `"C:<newline>ew<formfeed>ile"` because `\n` and `\f` are escape sequences in double-quoted strings. Forward slashes eliminate this entirely.
- **String concatenation without separator**: `"$dir$file"` loses the separator. Use `Join-Path`.
- **Relative paths with external tools**: Native executables may resolve relative paths from a different working directory than PowerShell's `$PWD`. Always pass absolute paths to external tools.
- **Mixed separators**: `"C:/Users\User/Documents"` works in PowerShell but may confuse external tools. Normalize to one style.

## Output From This Skill

When using this skill, state:

- what separator convention you are using and why
- whether paths are absolute or relative
- whether any paths may contain spaces or special characters
- what normalization was applied before passing paths to external tools

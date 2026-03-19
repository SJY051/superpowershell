---
name: "windows-encoding-safe"
description: "Use when an agent reads, writes, or pipes text in Windows and needs to avoid encoding corruption, BOM artifacts, or codepage surprises."
---

# Windows Encoding Safe

English summary:
Use this skill when an agent handles text I/O in Windows and must keep encoding consistent and predictable.

한국어 요약:
이 스킬은 에이전트가 Windows에서 텍스트 입출력을 다룰 때, 인코딩을 일관되고 예측 가능하게 유지하도록 돕습니다.

## Use This Skill When

- reading or writing files where encoding matters
- piping output between processes and seeing garbled text
- working with non-ASCII characters (Korean, CJK, emoji, etc.)
- the agent produces files that another tool or agent will consume

## Core Rules

1. Assume the console is `chcp 65001` (UTF-8). If unsure, run `chcp` first.
2. When writing files in PowerShell, always specify `-Encoding UTF8`.
3. Be aware that Windows PowerShell 5.1 `-Encoding UTF8` emits a BOM; PowerShell 7 does not. If BOM-free output is required, prefer `pwsh` or use `[System.IO.File]::WriteAllText()`.
4. When reading files, do not assume encoding. Check for BOM or use `Get-Content -Encoding UTF8` explicitly.
5. Use forward slashes in paths — PowerShell resolves them correctly and they avoid escape-sequence collisions.

## Common Pitfalls

### PowerShell 5.1 BOM
```powershell
# This writes UTF-8 WITH BOM in 5.1:
Set-Content -Path out.txt -Value $data -Encoding UTF8

# BOM-free alternative:
[System.IO.File]::WriteAllText("out.txt", $data, [System.Text.UTF8Encoding]::new($false))
```

### Console codepage mismatch
```powershell
# Check current codepage
chcp
# Set to UTF-8 for the session
chcp 65001

# For persistent UTF-8 console, set in profile:
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
```

### Piped output encoding
```powershell
# When piping to external tools, PowerShell may re-encode.
# Force UTF-8 output encoding before piping:
$OutputEncoding = [System.Text.Encoding]::UTF8
```

### Out-String and Out-File defaults
```powershell
# Out-File defaults to UTF-16 LE in 5.1. Always specify:
$data | Out-File -FilePath out.txt -Encoding UTF8
```

## Output From This Skill

When using this skill, state:

- what encoding you are assuming and why
- whether BOM presence matters for the downstream consumer
- what codepage the console is set to
- any encoding flags you are adding to commands

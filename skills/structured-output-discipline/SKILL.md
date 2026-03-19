---
name: "structured-output-discipline"
description: "Use when an agent produces command output that another tool, agent, or script must parse — ensuring output is machine-readable, consistent, and free of visual noise."
---

# Structured Output Discipline

English summary:
Use this skill when command output must be reliably parsed by another agent, tool, or pipeline step.

한국어 요약:
이 스킬은 명령 출력을 다른 에이전트, 도구, 파이프라인 단계에서 신뢰성 있게 파싱해야 할 때 사용합니다.

## Use This Skill When

- an agent's output will be consumed by another agent or script
- the result needs to survive piping, logging, or round-trip serialization
- visual formatting (colors, tables, progress bars) could corrupt parsing
- the task requires extracting specific fields from command results

## Core Rules

1. Prefer `ConvertTo-Json` over `Format-Table` / `Format-List` when the consumer is a machine.
2. `Format-*` cmdlets produce **display strings**, not objects. Once formatted, data is lost.
3. Suppress ANSI escape sequences: use `-NoColor` flags, `$env:NO_COLOR = '1'`, or `$PSStyle.OutputRendering = 'PlainText'` (PowerShell 7.2+).
4. If the consumer expects plain text, use `Out-String` carefully — it adds trailing newlines and may wrap lines.
5. Always specify `-Depth` with `ConvertTo-Json` when objects have nested properties. Default depth is 2, which silently truncates.

## Patterns

### JSON output for agent consumption
```powershell
# Good — structured, parseable, depth-aware:
Get-Process | Select-Object Name, Id, CPU | ConvertTo-Json -Depth 3

# Bad — produces display strings, not data:
Get-Process | Format-Table Name, Id, CPU
```

### Suppressing ANSI noise
```powershell
# PowerShell 7.2+
$PSStyle.OutputRendering = 'PlainText'

# Environment variable (works with many CLI tools):
$env:NO_COLOR = '1'

# Per-command: many tools accept --no-color or --plain
git --no-pager log --oneline --no-color
```

### Safe Out-String usage
```powershell
# Out-String adds a trailing newline. Trim if needed:
$text = (Get-Process | Out-String).Trim()

# Beware of line wrapping — Out-String wraps at console width.
# Widen the buffer if needed:
$text = Get-Process | Out-String -Width 200
```

### Selecting before converting
```powershell
# Always select only the fields you need before ConvertTo-Json.
# Full objects may contain circular references or huge nested trees.
Get-ChildItem | Select-Object Name, Length, LastWriteTime | ConvertTo-Json -Depth 1
```

## Anti-Patterns

- **`Format-Table | ConvertTo-Json`**: This converts formatting metadata, not the original data. Always convert before formatting.
- **Relying on default `ConvertTo-Json` depth**: Nested properties silently become `"System.Object[]"` strings at depth 2.
- **Mixing colored output into parsed pipelines**: ANSI codes become literal `\e[32m` garbage in logs and JSON.
- **Using `Write-Host` for data**: `Write-Host` goes to the console, not the pipeline. Use `Write-Output` or return values.

## Output From This Skill

When using this skill, state:

- what format the output will be in (JSON, plain text, CSV)
- whether ANSI/color suppression is applied
- what depth or field selection is used
- who or what will consume the output

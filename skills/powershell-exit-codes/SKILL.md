---
name: "powershell-exit-codes"
description: "Use when an agent needs to reliably detect success or failure of commands in PowerShell, especially when mixing native executables and cmdlets."
---

# PowerShell Exit Codes

English summary:
Use this skill when an agent must reliably detect whether a command succeeded or failed in PowerShell.

한국어 요약:
이 스킬은 에이전트가 PowerShell에서 명령의 성공/실패를 정확히 감지해야 할 때 사용합니다.

## Use This Skill When

- running external executables (git, node, cargo, etc.) and checking results
- mixing PowerShell cmdlets with native commands in a pipeline
- the agent needs to decide "should I continue or stop?" after a command
- writing scripts that must propagate failure correctly

## Core Rules

1. `$LASTEXITCODE` is the exit code of the **last native executable**. It is NOT updated by cmdlets.
2. `$?` is `$true`/`$false` for the **last statement** (cmdlet or native). But it resets on every statement — check it immediately.
3. `$ErrorActionPreference = 'Stop'` only affects **cmdlets and .NET calls**. Native executables ignore it entirely.
4. A native command can fail (non-zero exit) without throwing. You must check explicitly.
5. Do not rely on `$?` alone for native commands — always check `$LASTEXITCODE`.

## Patterns

### Safe native command check
```powershell
git pull origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error "git pull failed with exit code $LASTEXITCODE"
    return
}
```

### Wrapping native commands to throw on failure
```powershell
function Invoke-Native {
    param([scriptblock]$Command)
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE"
    }
}

Invoke-Native { cargo build --release }
```

### Cmdlet error handling
```powershell
# For cmdlets, try/catch works when ErrorAction is Stop:
try {
    Get-Item "C:/nonexistent" -ErrorAction Stop
} catch {
    Write-Error "Failed: $_"
}
```

### Pipeline with mixed commands
```powershell
# DANGEROUS — $LASTEXITCODE may be stale from a previous native call:
Get-ChildItem *.rs
# $LASTEXITCODE is still from the LAST native exe, not from Get-ChildItem

# SAFE — reset before using:
$LASTEXITCODE = 0
```

## Common Pitfalls

- **Stale `$LASTEXITCODE`**: It persists until the next native exe runs. If you run three cmdlets after a failed `git` call, `$LASTEXITCODE` is still non-zero.
- **`$ErrorActionPreference = 'Stop'` does not catch native failures**: The most common mistake. The agent thinks all errors will throw, but `curl.exe` returning 1 is completely silent.
- **`-ErrorAction Stop` on native commands**: This parameter only works on cmdlets. Adding it to a native exe call does nothing.

## Output From This Skill

When using this skill, state:

- whether the command is a cmdlet or native executable
- which exit-code mechanism you are checking (`$LASTEXITCODE` vs `$?` vs `try/catch`)
- what happens on failure (stop, retry, log, or continue)

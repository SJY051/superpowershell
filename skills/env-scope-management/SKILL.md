---
name: "env-scope-management"
description: "Use when an agent needs to read, set, or persist environment variables in Windows, understanding Process/User/Machine scope differences."
---

# Environment Scope Management

English summary:
Use this skill when an agent works with environment variables in Windows and needs to understand scope, persistence, and precedence.

한국어 요약:
이 스킬은 에이전트가 Windows에서 환경 변수를 다룰 때, 스코프·영속성·우선순위를 이해하고 올바르게 설정하도록 돕습니다.

## Use This Skill When

- setting environment variables that must survive across sessions
- debugging "it worked in this session but not the next one"
- an agent needs to add to PATH or set API keys
- multiple agents or tools share environment state

## Core Rules

1. `$env:VAR = "value"` sets a **Process-scope** variable. It dies when the session ends.
2. To persist, use `[Environment]::SetEnvironmentVariable("VAR", "value", "User")` or `"Machine"`.
3. Machine-scope requires **admin elevation**. Prefer User-scope unless system-wide is truly needed.
4. Precedence: Machine → User → Process. A Process-scope value overrides User and Machine for that session.
5. Changes to User/Machine scope do **not** affect the current session. The agent must also set `$env:VAR` if the current session needs the value immediately.

## Patterns

### Read from all scopes
```powershell
# Current session (effective value):
$env:MY_VAR

# Specific scope:
[Environment]::GetEnvironmentVariable("MY_VAR", "Process")
[Environment]::GetEnvironmentVariable("MY_VAR", "User")
[Environment]::GetEnvironmentVariable("MY_VAR", "Machine")
```

### Set temporarily (current session only)
```powershell
$env:MY_VAR = "temp_value"
```

### Set persistently (survives restart)
```powershell
# User-scope (no admin needed):
[Environment]::SetEnvironmentVariable("MY_VAR", "my_value", "User")

# Also apply to current session:
$env:MY_VAR = "my_value"
```

### Append to PATH safely
```powershell
# Read current User PATH:
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")

# Check if already present:
$newDir = "C:/tools/bin"
if ($userPath -notlike "*$newDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$newDir", "User")
    # Also update current session:
    $env:PATH += ";$newDir"
}
```

### Remove an environment variable
```powershell
# Remove from User scope (set to $null):
[Environment]::SetEnvironmentVariable("MY_VAR", $null, "User")

# Remove from current session:
Remove-Item Env:\MY_VAR -ErrorAction SilentlyContinue
```

## Common Pitfalls

- **"I set it but it's gone"**: `$env:VAR = ...` is process-only. If you need it next session, use `[Environment]::SetEnvironmentVariable()`.
- **"I persisted it but this session doesn't see it"**: Persisting to User/Machine updates the registry but not the live process. Set `$env:VAR` too.
- **PATH separator**: Windows uses `;` not `:`. Forgetting this corrupts PATH.
- **Machine scope without elevation**: Silently fails or throws. Always check if admin is needed first.

## Output From This Skill

When using this skill, state:

- which scope you are targeting and why
- whether the change needs to persist beyond the session
- whether elevation is required
- whether the current session also needs the updated value

---
name: "windows-shell-safety"
description: "Use when an agent is about to run commands in Windows PowerShell and needs calm, explicit, low-noise execution with clear shell assumptions."
---

# Windows Shell Safety

English summary:
Use this skill when an agent is about to run commands in Windows PowerShell and needs to keep command execution calm, predictable, and explicit.

한국어 요약:
이 스킬은 에이전트가 Windows PowerShell에서 명령을 실행하려고 할 때, 실행을 차분하고 예측 가능하며 명시적으로 유지하도록 돕습니다.

## Use This Skill When

- the task runs in Windows PowerShell or `pwsh`
- shell differences might matter
- aliases or wrappers could change command behavior
- the agent needs to avoid startup noise or fragile profile side effects

## Core Rules

1. Prefer `pwsh` as the default modern shell.
2. Use `-NoLogo` and `-NoProfile` when you need a clean baseline.
3. Do not assume Windows PowerShell 5.1 and PowerShell 7 behave the same way.
4. Treat aliases and wrappers as behavior changes, not cosmetic details.
5. Prefer explicit commands over guesswork when the environment is unclear.

## Operational Guidance

- If the shell environment is unknown, first check what shell is available.
- If a profile is needed, keep it narrow and purpose-specific.
- If a tool exists only in login-shell PATH, prefer fixing the PATH story over relying on hidden shell state.
- If a task truly depends on POSIX shell semantics, prefer WSL rather than forcing PowerShell to imitate Unix badly.

## Output From This Skill

When using this skill, state:

- which shell you are assuming
- whether you need a clean baseline or a richer profile
- what command-resolution risks matter
- what the safest next command is

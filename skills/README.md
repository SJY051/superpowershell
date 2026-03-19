# SuperPowerShell Skills / SuperPowerShell 스킬

This folder contains example skills for agents that work in Windows PowerShell-heavy environments.  
이 폴더는 Windows PowerShell 중심 환경에서 일하는 에이전트를 위한 예시 스킬을 담습니다.

These skills are intentionally generic. They are not tied to a private local toolchain.  
이 스킬들은 의도적으로 범용적으로 작성되었으며, 비공개 로컬 툴체인에 묶여 있지 않습니다.

## Included Skills / 포함된 스킬

### Foundation / 기본

- [windows-shell-safety](windows-shell-safety/SKILL.md) - run commands safely and predictably in Windows PowerShell
- [tool-registry-first](tool-registry-first/SKILL.md) - prefer an explicit tool registry over guessing command names
- [agent-exec-profile](agent-exec-profile/SKILL.md) - design a low-noise execution profile for local coding agents

### I/O & Error Handling / 입출력 & 에러 처리

- [windows-encoding-safe](windows-encoding-safe/SKILL.md) - avoid encoding corruption, BOM artifacts, and codepage surprises
- [powershell-exit-codes](powershell-exit-codes/SKILL.md) - reliably detect success or failure of commands
- [structured-output-discipline](structured-output-discipline/SKILL.md) - produce machine-readable output free of visual noise
- [windows-path-handling](windows-path-handling/SKILL.md) - construct and resolve file paths without common Windows pitfalls

### Productivity & Tools / 생산성 & 도구

- [env-scope-management](env-scope-management/SKILL.md) - manage environment variables across Process/User/Machine scopes
- [process-port-inspection](process-port-inspection/SKILL.md) - find processes, check ports, manage services
- [file-search-patterns](file-search-patterns/SKILL.md) - search files and content using the best available tool
- [git-on-windows](git-on-windows/SKILL.md) - handle Windows-specific git configuration and pitfalls
- [winget-essentials](winget-essentials/SKILL.md) - install and manage packages with the native Windows package manager

## Design Goals / 설계 목표

- public-facing guidance
- Windows-aware command behavior
- low-noise agent execution
- explicit discovery over command-name guessing
- compatibility with bilingual documentation projects

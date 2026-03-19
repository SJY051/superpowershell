# SuperPowerShell Skills / SuperPowerShell 스킬

This folder contains example skills for agents that work in Windows PowerShell-heavy environments.  
이 폴더는 Windows PowerShell 중심 환경에서 일하는 에이전트를 위한 예시 스킬을 담습니다.

These skills are intentionally generic. They are not tied to a private local toolchain.  
이 스킬들은 의도적으로 범용적으로 작성되었으며, 비공개 로컬 툴체인에 묶여 있지 않습니다.

## Included Skills / 포함된 스킬

- [windows-shell-safety](windows-shell-safety/SKILL.md) - run commands safely and predictably in Windows PowerShell
- [tool-registry-first](tool-registry-first/SKILL.md) - prefer an explicit tool registry over guessing command names
- [agent-exec-profile](agent-exec-profile/SKILL.md) - design a low-noise execution profile for local coding agents

## Design Goals / 설계 목표

- public-facing guidance
- Windows-aware command behavior
- low-noise agent execution
- explicit discovery over command-name guessing
- compatibility with bilingual documentation projects

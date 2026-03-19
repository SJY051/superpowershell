---
name: "tool-registry-first"
description: "Use when an agent should inspect a tool registry or inventory before guessing command names in a customized Windows shell environment."
---

# Tool Registry First

English summary:
Use this skill when an agent needs to choose commands in a customized shell environment and should prefer explicit discovery over guessing.

한국어 요약:
이 스킬은 에이전트가 커스터마이즈된 셸 환경에서 명령을 선택할 때, 추측보다 명시적 도구 조회를 우선하도록 돕습니다.

## Use This Skill When

- the shell has multiple overlapping tools
- aliases or preferred defaults may change command choice
- the environment exposes a `tools`-style registry or machine-readable tool inventory

## Core Rules

1. Prefer explicit discovery over memorized assumptions.
2. If a tool registry exists, query it before inventing command names.
3. When multiple tools overlap, use the documented representative default unless the task needs a specific alternative.
4. Preserve alternatives, but make the default obvious.

## Good Questions To Answer

- What tools exist for this role?
- Which one is the preferred default?
- Is there a POSIX analogue the user or agent is likely expecting?
- Does the output favor humans, machines, or both?

## Output From This Skill

When using this skill, summarize:

- the chosen command
- why it is the default
- what alternatives exist
- any caveats about aliases, shell support, or output style

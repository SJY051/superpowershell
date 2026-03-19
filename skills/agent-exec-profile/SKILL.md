---
name: "agent-exec-profile"
description: "Use when designing or auditing a low-noise PowerShell execution profile for local coding agents so automation stays predictable and quiet."
---

# Agent Exec Profile

English summary:
Use this skill when designing or auditing a low-noise PowerShell execution profile for local coding agents.

한국어 요약:
이 스킬은 로컬 코딩 에이전트를 위한 저잡음 PowerShell 실행 프로필을 설계하거나 점검할 때 사용합니다.

## Goal

Create a profile that is safe for automation but still useful for real work.

## Include

- essential path setup
- stable tool integrations
- representative aliases that are clearly documented
- fallback behavior for optional tools
- only the minimum helper surface the agent truly needs

## Exclude By Default

- decorative prompts
- interactive-only modules
- startup chatter
- broad machine-policy mutations
- hidden wrappers that change behavior without documentation

## Recommended Pattern

Split the profile by responsibility:

- core
- paths
- integrations
- aliases
- navigation
- local overrides

Keep the execution profile narrower than the full interactive profile.

## Output From This Skill

When using this skill, explain:

- what belongs in the exec profile
- what should stay only in the interactive profile
- what fallback behavior exists if optional tools are missing
- what risks remain if the profile grows too broad

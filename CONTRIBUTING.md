# Contributing / 기여 안내

Thank you for improving SuperPowerShell.  
SuperPowerShell를 개선해 주셔서 감사합니다.

## Project Direction / 프로젝트 방향

This repository is for a **public, agent-friendly Windows PowerShell guide**.  
이 레포는 **공개형 에이전트 친화 Windows PowerShell 가이드**를 위한 공간입니다.

Please keep contributions aligned with these principles:
기여 시 다음 원칙을 지켜 주세요.

- Prefer public, reproducible guidance over private local conventions.
- Keep docs bilingual when touching major user-facing content.
- Prefer relative links over absolute filesystem paths.
- Document representative defaults clearly when tools overlap.
- Prefer preview-first install examples and avoid normalizing risky shortcuts.

## Documentation Rules / 문서 규칙

- Keep English and Korean docs aligned in scope and intent.
- If you add a new major page in one language, add or update the counterpart.
- Do not describe private helper names or internal workflows as if they are universal public requirements.
- Mark examples as examples and shipped files as shipped files.

## Source Quality / 출처 품질

- Prefer official or primary sources for installation methods, version guidance, and caveats.
- If a recommendation is based on inference rather than explicit upstream guidance, say so.

## Scripts and Safety / 스크립트와 안전성

- New install scripts should support a preview mode when practical.
- Avoid changing broad machine policy by default.
- Prefer isolated or user-local installs for optional extras.
- Explain what a script changes and where it writes.

## Skills and Agent Patterns / 스킬과 에이전트 패턴

- Keep reusable skills generic and public-facing.
- Avoid embedding private environment assumptions into shipped skill files.
- If a skill depends on a local convention, document that dependency explicitly.

## Suggested Review Checklist / 권장 검토 목록

- No absolute local filesystem paths
- No hidden private toolchain assumptions
- Public links render correctly on GitHub
- English and Korean docs still match
- Scripts preview correctly

## Licensing / 라이선스

By contributing, you agree that your contributions are provided under the repository license.  
기여하신 내용은 이 레포의 라이선스 조건에 따라 배포되는 데 동의한 것으로 간주합니다.

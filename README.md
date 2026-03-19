# SuperPowerShell

An agent-friendly Windows PowerShell environment guide for humans and local coding agents.  
사람과 로컬 코딩 에이전트를 위한, 에이전트 친화적인 Windows PowerShell 환경 가이드입니다.

This repository is best understood as a **public guide + starter kit + optional feature set** for building an agent-friendly Windows PowerShell environment. The goal is not to install every interesting CLI, but to provide working defaults, reusable scripts, and clear operational guidance that make the shell easier for humans to read, easier for agents to parse, and predictable enough to automate safely.  
이 레포지토리는 에이전트 친화적인 Windows PowerShell 환경을 만들기 위한 **공개형 가이드 + 스타터 킷 + 선택 기능 묶음**으로 이해하는 편이 가장 정확합니다. 목표는 흥미로운 CLI를 전부 설치하는 것이 아니라, 사람이 읽기 좋고 에이전트가 파싱하기 쉬우며 자동화하기에도 예측 가능한 셸 환경을 만들 수 있도록, 실제로 동작하는 기본값과 재사용 가능한 스크립트, 그리고 명확한 운영 가이드를 제공하는 것입니다.

## Why This Exists / 왜 필요한가

Modern AI agents often assume a Unix-like shell.  
현대의 AI 에이전트는 대체로 Unix 계열 셸 환경을 전제로 동작하는 경우가 많습니다.

- `rg` instead of slow recursive search / 느린 재귀 검색 대신 `rg`
- `fd` instead of awkward file traversal / 불편한 파일 순회 대신 `fd`
- `jq` and `yq` for structured output / 구조화된 출력 처리를 위한 `jq`, `yq`
- predictable command names, stable aliases, and low-noise shells / 예측 가능한 명령 이름, 안정적인 별칭, 잡음이 적은 셸 환경

However, the default Windows shell environment often has the following problems.  
하지만 Windows 기본 셸 환경은 대체로 다음과 같은 문제를 갖고 있습니다.

- it is hard to see at a glance which tools are installed / 어떤 도구가 설치되어 있는지 한눈에 파악하기 어렵다
- even when multiple tools serve the same role, the preferred one is not obvious / 같은 역할의 도구가 여러 개 있어도 대표 도구가 드러나지 않는다
- default aliases and PowerShell-specific semantics often diverge from POSIX expectations / 기본 별칭과 PowerShell 전용 의미론 때문에 POSIX 감각과 어긋난다
- unnecessary startup noise can easily appear when the shell launches / 셸 시작 시 불필요한 잡음이 생기기 쉽다

This repository documents one practical answer.  
이 레포지토리는 그에 대한 하나의 실용적인 해답을 정리합니다.

- prefer **PowerShell 7.5+** / **PowerShell 7.5+**를 우선 사용
- keep **Windows PowerShell 5.1** only for compatibility / **Windows PowerShell 5.1**은 호환성용으로만 유지
- use a **low-noise exec profile** for agents / 에이전트를 위한 **저잡음 exec 프로필** 사용
- expose a **tool registry** with preferred commands and metadata / 대표 명령과 메타데이터를 담은 **tool registry** 제공
- keep human-friendly defaults without sacrificing machine readability / 사람 친화적인 기본값을 유지하되 기계 가독성을 해치지 않음

## Recommended PowerShell Version / 권장 PowerShell 버전

- Recommended: **PowerShell 7.5 or newer** / 권장: **PowerShell 7.5 이상**
- Minimum practical baseline: **PowerShell 7.4+** / 실사용 최소 기준: **PowerShell 7.4+**
- Compatibility only: **Windows PowerShell 5.1** / 호환성 전용: **Windows PowerShell 5.1**

PowerShell 7+ is strongly preferred because it offers better performance, modern module compatibility, improved ANSI support, and a cleaner foundation for agent-oriented tooling.  
PowerShell 7+는 더 나은 성능, 최신 모듈 호환성, 향상된 ANSI 지원, 그리고 에이전트 지향 도구 구성을 위한 더 깔끔한 기반을 제공하므로 강력히 권장됩니다.

## Repo Structure / 레포지토리 구조

- [docs/en/README.md](docs/en/README.md) - English index / 영문 인덱스
- [docs/ko/README.md](docs/ko/README.md) - Korean index / 한국어 인덱스
- [docs/en/install.md](docs/en/install.md) - English install guide / 영문 설치 가이드
- [docs/ko/install.md](docs/ko/install.md) - Korean install guide / 한국어 설치 가이드
- [docs/en/agent-quickstart.md](docs/en/agent-quickstart.md) - short setup path for local agents / 로컬 에이전트용 짧은 설정 경로
- [docs/ko/agent-quickstart.md](docs/ko/agent-quickstart.md) - short setup path for local agents in Korean / 한국어 로컬 에이전트용 짧은 설정 경로
- [docs/en/tools.md](docs/en/tools.md) - tool catalog and installation guidance / 툴 카탈로그와 설치 안내
- [docs/ko/tools.md](docs/ko/tools.md) - tool catalog and installation guidance in Korean / 한국어 툴 카탈로그와 설치 안내
- [docs/en/shell-matrix.md](docs/en/shell-matrix.md) - shell coverage and differences / 셸 커버리지와 차이
- [docs/ko/shell-matrix.md](docs/ko/shell-matrix.md) - shell coverage and differences in Korean / 한국어 셸 커버리지와 차이
- [docs/en/profile-architecture.md](docs/en/profile-architecture.md) - profile layout and load strategy / 프로필 구조와 로드 전략
- [docs/ko/profile-architecture.md](docs/ko/profile-architecture.md) - profile layout and load strategy in Korean / 한국어 프로필 구조와 로드 전략
- [docs/en/aliases.md](docs/en/aliases.md) - recommended aliases and command mappings / 추천 별칭과 명령 대응표
- [docs/ko/aliases.md](docs/ko/aliases.md) - recommended aliases and command mappings in Korean / 한국어 추천 별칭과 명령 대응표
- [docs/en/scripts.md](docs/en/scripts.md) - PowerShell helper scripts and profile patterns / PowerShell 보조 스크립트와 프로필 패턴
- [docs/ko/scripts.md](docs/ko/scripts.md) - PowerShell helper scripts and profile patterns in Korean / 한국어 PowerShell 보조 스크립트와 프로필 패턴
- [docs/en/skills.md](docs/en/skills.md) - extra skills for Windows-friendly agents / Windows 친화 에이전트를 위한 추가 스킬
- [docs/ko/skills.md](docs/ko/skills.md) - extra skills for Windows-friendly agents in Korean / 한국어 Windows 친화 에이전트를 위한 추가 스킬
- [docs/en/troubleshooting.md](docs/en/troubleshooting.md) - troubleshooting notes / 문제 해결 메모
- [docs/ko/troubleshooting.md](docs/ko/troubleshooting.md) - troubleshooting notes in Korean / 한국어 문제 해결 메모
- [SECURITY.md](SECURITY.md) - release and operational safety notes / 공개 및 운용 보안 메모
- [CONTRIBUTING.md](CONTRIBUTING.md) - contribution guidance / 기여 안내
- [skills/README.md](skills/README.md) - example reusable skills for Windows-friendly agents / Windows 친화 에이전트를 위한 예시 스킬
- [features/tools-registry/README.md](features/tools-registry/README.md) - optional installable `tools` / `tools-add` feature / 선택 설치 가능한 `tools` / `tools-add` 기능
- [scripts/bootstrap-all.ps1](scripts/bootstrap-all.ps1) - preview-first all-in-one bootstrap / 미리보기 우선 전체 부트스트랩

## What This Repo Emphasizes / 이 레포지토리가 강조하는 것

- **Structured tools first**: favor tools that produce parseable output or predictable behavior  
  **구조화된 도구 우선**: 파싱 가능한 출력이나 예측 가능한 동작을 제공하는 도구를 우선합니다.

- **Representative commands**: keep alternatives when useful, but mark one default tool for each role  
  **대표 명령 지정**: 대체 도구는 필요할 때 유지하되, 역할별 기본 도구 하나를 명확히 표시합니다.

- **Agent-safe shell startup**: avoid decorative noise and fragile startup side effects  
  **에이전트 안전한 셸 시작**: 장식성 잡음과 취약한 시작 부작용을 피합니다.

- **Bilingual documentation**: every major document is available in English and Korean  
  **이중언어 문서화**: 주요 문서는 모두 영어와 한국어로 제공합니다.

- **Practical Windows fit**: do not pretend Windows is Linux; document where PowerShell differs and where WSL is still the better answer  
  **실용적인 Windows 적합성**: Windows를 Linux인 척 다루지 않고, PowerShell이 어디서 다르고 어디서는 여전히 WSL이 더 나은지 명확히 설명합니다.

## Current Direction / 현재 방향

This repository currently focuses on the following areas.  
이 레포지토리는 현재 다음 영역에 집중합니다.

- search and file discovery / 검색과 파일 탐색
- structured data processing / 구조화된 데이터 처리
- navigation and listing / 이동과 목록화
- HTTP/API work / HTTP/API 작업
- task running and verification / 작업 실행과 검증
- PowerShell profile design / PowerShell 프로필 설계
- local coding agent workflows / 로컬 코딩 에이전트 워크플로우
- bootstrap scripts for first-run setup / 첫 실행 설정을 위한 부트스트랩 스크립트

## Notes / 참고 사항

- This is not a generic “install every cool CLI” list.  
  이것은 흔한 “멋진 CLI를 전부 설치하자” 식의 목록이 아닙니다.

- This is not a replacement for WSL when true POSIX shell semantics are required.  
  이것은 진정한 POSIX 셸 의미론이 필요한 경우 WSL을 대체하려는 것이 아닙니다.

- This is a guide for building a **calm, low-friction, agent-usable Windows shell**.  
  이것은 **차분하고, 마찰이 적고, 에이전트가 활용 가능한 Windows 셸**을 구축하기 위한 가이드입니다.

- This repository documents patterns, scripts, and recommended tools. It does not assume any private local toolchain or hidden internal dependency.  
  이 레포지토리는 패턴, 스크립트, 권장 도구를 문서화합니다. 특정 개인 환경의 비공개 툴체인이나 숨은 내부 의존성을 전제하지 않습니다.

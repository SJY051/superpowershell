# SuperPowerShell 문서 (한국어)

## 개요

이 문서는 사람과 로컬 코딩 에이전트가 함께 쓰기 좋은, 차분하고 예측 가능하며 어느 정도 Unix 감각을 유지하는 Windows PowerShell 환경을 만드는 방법을 설명합니다.

이 레포는 완성형 제품이라기보다, 공개형 가이드와 스타터 킷에 더 가깝습니다.

## 문서 구성

- [tools.md](tools.md) - 핵심/확장 툴 카탈로그, 설치 방법, POSIX 대응 관계, 실제 효용
- [install.md](install.md) - 사람/에이전트용 설치 가이드
- [agent-quickstart.md](agent-quickstart.md) - 로컬 에이전트용 짧은 시작 가이드
- [shell-matrix.md](shell-matrix.md) - 셸 종류와 차이
- [profile-architecture.md](profile-architecture.md) - 모듈형 PowerShell 프로필 구조
- [aliases.md](aliases.md) - 추천 aliases와 명령 치환 규칙
- [scripts.md](scripts.md) - 유용한 PowerShell 보조 스크립트, 프로필 패턴, 에이전트용 헬퍼
- [skills.md](skills.md) - Windows 중심 에이전트 워크플로에 도움이 되는 추가 스킬 아이디어
- [troubleshooting.md](troubleshooting.md) - 자주 생기는 문제와 원인
- [../../skills/README.md](../../skills/README.md) - 레포에 포함된 예시 스킬 모음
- [../../CONTRIBUTING.md](../../CONTRIBUTING.md) - 공개형 문서/스크립트를 위한 기여 안내
- [../../SECURITY.md](../../SECURITY.md) - 공개 및 운용 보안 메모

## 전제

이 레포는 아래 환경을 기준으로 합니다.

- 메인 호스트 OS는 Windows
- 기본 셸은 PowerShell 7.5+
- 로컬 코딩 에이전트 사용
- 구조화된 출력, 재현 가능한 셸 동작, 낮은 시작 잡음을 선호

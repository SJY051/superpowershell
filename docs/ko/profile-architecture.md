# 프로필 아키텍처

이 가이드는 하나의 거대한 PowerShell 프로필 파일 대신, 역할별 `profile.d` 레이아웃을 권장합니다.

## 기본 아이디어

시작 로직을 책임별로 나눕니다.

- core helpers
- path bootstrap
- tool integrations
- aliases
- navigation/listing
- tool registry
- legacy functions

## 예시 파일 레이아웃

| 파일 | 목적 |
| --- | --- |
| `00-core.ps1` | 안전한 공통 헬퍼, 환경 보정, 조용한 기본값 |
| `10-paths.ps1` | 사용자 전용 CLI 도구 경로 추가 |
| `20-integrations.ps1` | `direnv`, `PSFzf`, `zoxide` 같은 선택적 통합 |
| `30-aliases.ps1` | `cat`, `find`, `grep` 같은 대표 별칭 |
| `40-navigation.ps1` | 목록 출력과 디렉터리 이동 관련 동작 |
| `50-registry.ps1` | 도구 인벤토리나 대표 명령 내보내기 |
| `90-local.ps1` | 사용자 또는 장비 전용 로컬 오버라이드 |

이 이름들은 예시일 뿐, 반드시 따라야 하는 표준은 아닙니다.

## 에이전트 안전 변형

에이전트에게는 장식성/interactive 전용 모듈을 기본으로 불러오지 않는 저잡음 exec profile이 별도로 있는 편이 좋습니다.

## 왜 잘 작동하는가

이 구조는 다음 장점이 있습니다.

- 시작 실패를 분리해 찾기 쉬움
- 동작 변화 설명이 쉬움
- 안전한 subset만 불러오기 쉬움
- 오래된 호환 헬퍼가 기본 시작 경로를 더럽히지 않음


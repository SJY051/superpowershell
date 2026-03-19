# 이 환경을 적용하면 달라지는 것

이 문서는 SuperPowerShell 베이스라인을 적용했을 때 실제로 바뀌는 동작을 정리합니다. 부트스트랩을 실행하기 전에 읽고, 무엇을 수용하는 것인지 파악할 수 있도록 합니다.

## 동작이 바뀌는 명령

추천 aliases를 적용하면, 다음 명령은 기본 PowerShell과 다르게 동작합니다.

| 명령 | 적용 전 (기본 PowerShell) | 적용 후 (이 환경) |
| --- | --- | --- |
| `cat` | `Get-Content` | `bat` (문법 강조 파일 뷰어) |
| `ls` | `Get-ChildItem` | `eza` (아이콘 포함 현대적 디렉터리 listing) |
| `find` | 없거나 모호 | `fd` (재귀 파일 탐색) |
| `grep` | 없음 | `rg` (ripgrep, 빠른 텍스트 검색) |
| `cd` | `Set-Location` | `zoxide` 인지 wrapper (자주 가는 디렉터리를 학습) |
| `curl` | `Invoke-WebRequest` (내장 alias) | 변경 없음, 단 진짜 바이너리는 `curl.exe`로 호출 |

## PATH에 추가되는 것

부트스트랩은 사용자 수준의 도구 디렉터리를 `PATH`에 추가할 수 있습니다.

- npm 글로벌 prefix (기본 `~\.local\npm-tools`) — 에이전트 보조 도구용
- Python 사용자 스크립트 디렉터리
- `profile.d/` 경로 파일에 명시된 경로

## 프로필 로딩 변경

- PowerShell 프로필에 `profile.d/` 로더가 추가됩니다 (아직 없는 경우)
- 시작 로직이 번호 순서대로 로드되는 파일들로 분리됩니다
- Interactive 전용 모듈 (프롬프트 테마, `PSReadLine` 설정)은 에이전트 exec 프로필에 포함되지 않습니다

## 환경 변수

`00-core.ps1` 조각은 XDG 기본 디렉터리가 아직 없으면 설정합니다.

- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_CACHE_HOME` → `~/.cache`
- `XDG_DATA_HOME` → `~/.local/share`

Unix 지향 도구들이 Windows에서도 일관되게 동작하도록 돕습니다.

## 바뀌지 않는 것

- 시스템 전체 정책은 수정되지 않음
- 기존 도구는 삭제되지 않음
- `powershell` (5.1)은 제거되거나 변경되지 않음
- 원래 명령은 전체 이름으로 여전히 사용 가능 (예: `Get-ChildItem`, `Get-Content`)
- WSL은 영향받지 않음

## 되돌리기

되돌리려면:

1. PowerShell 프로필에서 `profile.d/` 로더를 제거
2. `profile.d/` 디렉터리 삭제
3. 필요하면 `winget uninstall`로 도구 제거

모든 변경은 영구적이지 않으며 되돌릴 수 있습니다.

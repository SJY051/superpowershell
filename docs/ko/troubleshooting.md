# 문제 해결

## 셸 시작 시 잡음이 많다

흔한 원인:

- 오래된 프롬프트 모듈
- 비대화형 셸에서 interactive 전용 설정까지 불러오는 경우
- 깨진 테마 캐시
- Unix 스타일 설정 디렉터리를 가정하는 통합 도구

## 도구는 설치됐는데 호출이 안 된다

다음부터 확인합니다.

- 사용자 전용 경로에 설치됐는데 아직 `PATH`에 안 들어갔는지
- 로그인 셸에서만 보이는지
- 패키지 매니저가 비표준 shim 경로에 설치했는지

## 명령이 기본 PowerShell과 다르게 동작한다

의도적인 변화일 수 있습니다.

예:

- `cat -> bat`
- `cd` + `zoxide`
- `ls -> eza`

## 어떤 기능이 조용히 동작하지 않는다

일부 통합은 셸 시작을 조용히 유지하려고 일부러 실패를 숨깁니다.

예:

- `direnv` 없음
- `PSFzf` 없음
- `eza` 없음

이 경우 셸은 크래시 대신 fallback으로 내려갑니다.

## `curl`이 진짜 curl처럼 동작하지 않는다

기본 PowerShell에서 `curl`은 `Invoke-WebRequest`의 alias입니다. 따라서 `curl https://example.com`은 HTTP 원시 출력이 아니라 PowerShell 응답 객체를 반환합니다.

해결 방법:

- 진짜 curl 바이너리를 호출하려면 `curl.exe`를 명시적으로 사용
- 또는 기본 alias를 제거: `Remove-Item Alias:curl -Force -ErrorAction SilentlyContinue`
- 에이전트 실행 프로필에서는 `curl.exe`를 쓰는 편이 안전

이것은 Windows에서 에이전트와 Unix 경험자 모두가 가장 빠지기 쉬운 함정 중 하나입니다.

## 레거시 헬퍼가 아직 남아 있다

호환용이라는 점을 분명히 문서화해야 합니다.

예:

- 더 단순하고 더 잘 문서화된 경로가 생겼다면, 오래된 헬퍼를 기본 실행 경로로 계속 두지 않는 편이 좋습니다

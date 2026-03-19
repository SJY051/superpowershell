# PowerShell 스크립트와 프로필 패턴

이 가이드는 PowerShell 프로필을 역할별 조각으로 나누고, 사람 친화 레이어와 에이전트 안전 레이어를 분리하는 방식을 권장합니다.

## 추천 구조

프로필은 작고 역할이 분명한 파일들로 나누는 편이 좋습니다.

- `00-core.ps1`: 안전한 공통 헬퍼
- 로컬 CLI 경로를 여는 path/bootstrap 파일
- `direnv`, `PSFzf`, 디렉터리 점프 도구 같은 통합 파일
- 대표 명령 매핑용 별칭 파일
- `eza`, `zoxide`용 목록/이동 파일
- 도구 인벤토리나 대표 명령 조회를 위한 레지스트리 파일
- 오래된 호환 함수는 따로 격리

## 왜 중요한가

거대한 단일 프로필은 고치기 어렵고 깨지기 쉽습니다. 반대로 모듈형 프로필은:

- 시작 잡음을 줄이고
- 문제 위치를 빨리 찾게 해 주며
- 에이전트가 필요한 subset만 불러올 수 있게 하고
- 비대화형 환경에서 장식성 모듈이 끼어드는 걸 막습니다

## 에이전트 관점에서 유용한 패턴

### 1. 저잡음 exec profile

에이전트용으로는 별도의 가벼운 프로필이 유용합니다.

- 장식 프롬프트 없음
- interactive 전용 모듈 없음
- 대신 경로, alias, 통합, 헬퍼만 유지

### 2. 도구 레지스트리 헬퍼

대표 도구, 셸 커버리지, 별칭 정보를 기계가 읽을 수 있는 방식으로 노출하면 에이전트가 명령 이름을 추측하지 않아도 됩니다.

### 3. XDG 계열 경로 보정

Windows에서도 `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, `XDG_DATA_HOME`을 잡아 두면 Unix 지향 도구들이 더 일관되게 동작하는 경우가 많습니다.

### 4. 명시적인 대체 동작

선택적 통합이 없을 때는 큰 오류를 내기보다 차분한 대체 경로로 내려가는 편이 좋습니다.

## 레포에 포함된 스크립트

- [../../scripts/install-core-tools-winget.ps1](../../scripts/install-core-tools-winget.ps1) - 권장 베이스라인 설치 명령을 미리 보고 적용
- [../../scripts/install-agent-extras.ps1](../../scripts/install-agent-extras.ps1) - 좀 더 격리된 기본값으로 에이전트 보조 도구를 미리 보고 적용
- [../../scripts/bootstrap-all.ps1](../../scripts/bootstrap-all.ps1) - 베이스라인 설치, 프로필 설정, 인벤토리 부트스트랩, 선택 기능, 예시 스킬 설치를 한 번에 묶는 진입점
- [../../scripts/bootstrap-profile.ps1](../../scripts/bootstrap-profile.ps1) - 모듈형 `profile.d` 스캐폴드와 로더 생성
- [../../scripts/bootstrap-tools-inventory.ps1](../../scripts/bootstrap-tools-inventory.ps1) - 현재 설치된 명령 기준의 starter `terminal-tools.json` 생성
- [../../scripts/install-skills.ps1](../../scripts/install-skills.ps1) - 레포에 포함된 예시 스킬을 원하는 스킬 디렉터리에 설치
- [../../scripts/export-preferred-tools.ps1](../../scripts/export-preferred-tools.ps1) - 설정 가능한 인벤토리 디렉터리에서 대표 도구만 JSON으로 출력
- [../../scripts/get-shell-matrix.ps1](../../scripts/get-shell-matrix.ps1) - 기본적으로 호스트 고유 정보를 생략한 셸 커버리지 JSON 출력
- [../../features/tools-registry/README.md](../../features/tools-registry/README.md) - `tools`와 `tools-add`를 추가하는 선택 설치 기능

## 공개형 문서화 메모

자신만의 셸 헬퍼를 공개할 때는, 레포에 실제로 포함된 것과 개인 로컬 확장을 분명히 구분해 적는 편이 좋습니다.

# 설치 가이드

이 프로젝트는 설치를 두 층으로 나눕니다.

1. **핵심 셸 베이스라인** - 일상적인 셸 사용감을 실제로 바꾸는 도구
2. **에이전트 보조 도구** - 로컬 코딩 에이전트가 읽고, 파싱하고, 변환하고, 요약하는 데 도움이 되는 도구

## 사람용 빠른 시작

1. **PowerShell 7.5+** 설치
2. 핵심 CLI 베이스라인 설치
3. 필요하면 에이전트 보조 도구 추가
4. 원하는 프로필 조각만 선택 적용
5. 인터넷에서 가져온 프로필 조각을 적용하기 전에는 보안 메모를 먼저 확인

## 권장 핵심 베이스라인

아직 `pwsh`가 없다면, 먼저 Windows PowerShell / Windows Terminal / winget UI에서 `Microsoft.PowerShell`을 설치한 뒤 아래 스크립트를 다시 실행합니다.

먼저 미리보기:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-core-tools-winget.ps1 -WhatIf
```

출력을 검토한 뒤 실제 적용:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-core-tools-winget.ps1 -Apply -AcceptAgreements
```

이 스크립트는 `winget`으로 다음 핵심 도구를 설치합니다.

- `Microsoft.PowerShell`
- `BurntSushi.ripgrep.MSVC`
- `sharkdp.fd`
- `jqlang.jq`
- `MikeFarah.yq`
- `sharkdp.bat`
- `junegunn.fzf`
- `eza-community.eza`
- `ajeetdsouza.zoxide`
- `astral-sh.uv`
- `Casey.Just`
- `direnv.direnv`
- `ducaale.xh`
- `JohnMacFarlane.Pandoc`
- `Wilfred.difftastic`
- `sharkdp.hyperfine`
- `dandavison.delta`

## 에이전트 보조 도구

먼저 미리보기:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-agent-extras.ps1 -WhatIf
```

출력을 검토한 뒤 실제 적용:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\install-agent-extras.ps1 -Apply
```

이 스크립트는 좀 더 격리된 기본값을 우선합니다.

- `defuddle`는 사용자 전용 npm prefix
- `fx`는 사용자 전용 npm prefix
- `jc`는 `uv tool`, `pipx`, 또는 `pip --user`

## 왜 두 층으로 나누는가

핵심 베이스라인은 예측 가능하고 넓게 쓸 수 있어야 합니다.  
반면 보조 도구는 유용하지만 다음 전제를 가집니다.

- `npm` 사용 가능
- `uv`, `pipx`, 혹은 `pip --user` 같은 Python 도구 설치 경로 사용 가능
- 에이전트 친화 파싱/추출 도구를 실제로 원함

## PowerShell 호환성

- 권장 셸: `pwsh` 7.5+
- 호환 셸: Windows PowerShell 5.1
- aliases, wrappers, profile modules까지 들어가면 두 셸의 동작이 완전히 같다고 기대하면 안 됩니다

## 전제 도구

- 베이스라인 설치 스크립트에는 `winget` 필요
- JavaScript 계열 보조 도구에는 `npm` 필요
- Python 계열 보조 도구에는 `python`과 `uv`, `pipx`, 또는 `pip` 필요
- 패키지 매니저 정책에 따라 관리자 권한이 필요할 수 있음

## 안전 메모

- 스크립트는 실행 전에 먼저 읽어 보는 편이 좋습니다.
- 가능하면 미리보기부터 사용하세요.
- `ExecutionPolicy Bypass`를 로컬 설정의 기본 습관처럼 쓰지 않는 편이 좋습니다.
- 자신의 변형본을 공개할 때는 무엇이 설치되고 `PATH`에 어디가 추가되는지 분명히 적는 편이 안전합니다.

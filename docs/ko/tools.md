# 툴 카탈로그

이 문서는 에이전트 친화적인 Windows 셸에서 실제로 중요한 도구들을 정리합니다.

목표는 기계에 설치된 모든 명령을 다 적는 것이 아니라, **일상적인 셸 사용감을 실제로 바꾸는 도구들**을 설명하는 것입니다.

## 핵심 대표 스택

| 툴 | 역할 | POSIX 대응 | 왜 중요한가 | 간단 사용법 | 권장 Windows 설치 | 공식/1차 출처 | 주의점 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `pwsh` | 기본 셸 | `sh` / `bash` 계열 역할 | 더 현대적인 PowerShell, 더 나은 ANSI/모듈 호환성 | `pwsh -NoLogo -NoProfile` | `winget install --id Microsoft.PowerShell -e` | [Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) | Store/MSIX 설치는 remoting/server 기준으로 항상 최선은 아닙니다 |
| `rg` | 텍스트 검색 | `grep` | 빠른 재귀 검색, 기본 텍스트 검색 도구로 적합 | `rg "pattern" .` | `winget install --id BurntSushi.ripgrep.MSVC -e` | [ripgrep README](https://github.com/BurntSushi/ripgrep) | Windows에선 `MSVC` 패키지 ID를 쓰는 편이 자연스럽습니다 |
| `fd` | 파일 탐색 | `find` | 더 자연스러운 재귀 파일 탐색 | `fd profile` | `winget install --id sharkdp.fd -e` | [fd README](https://github.com/sharkdp/fd) | upstream의 npm 경로는 기본 Windows 설치 경로가 아닙니다 |
| `bat` | 파일 보기 | `cat` | 사람이 읽기 좋은 파일 출력 | `bat README.md` | `winget install --id sharkdp.bat -e` | [bat README](https://github.com/sharkdp/bat) | Windows에서는 Visual C++ Redistributable이 필요할 수 있습니다 |
| `jq` | JSON 처리 | `jq` | 기계 친화적인 JSON 필터링 | `curl ... | jq .` | `winget install --id jqlang.jq -e` | [jq download page](https://jqlang.org/download/) | 공식 Windows 바이너리는 패키지 매니저 경로와 별개로도 제공됩니다 |
| `yq` | YAML / JSON 처리 | `yq` | 설정 파일 처리에 강함 | `yq . config.yml` | `winget install --id MikeFarah.yq -e` | [yq README](https://github.com/mikefarah/yq) | Chocolatey는 upstream 기준 커뮤니티 지원 경로입니다 |
| `fzf` | 퍼지 선택 | 없음 | 파일, 히스토리, provider를 빠르게 고름 | `fd | fzf` | `winget install --id junegunn.fzf -e` | [fzf README](https://github.com/junegunn/fzf) | 설치 후 shell integration은 별도 설정이 필요합니다 |
| `eza` | 디렉터리 listing | `ls` | 더 표현력 좋은 listing 기본값 | `eza -la` | `winget install --id eza-community.eza -e` | [eza INSTALL.md](https://github.com/eza-community/eza/blob/main/INSTALL.md) | `cargo install eza`는 소스 빌드 경로입니다 |
| `zoxide` | 디렉터리 점프 | `cd` | 자주 가는 경로를 기억해 이동을 빠르게 함 | `z project-name` | `winget install --id ajeetdsouza.zoxide -e` | [zoxide README](https://github.com/ajeetdsouza/zoxide) | 설치만으로 끝나지 않고 PowerShell 프로필에 init hook이 필요합니다 |
| `uv` | Python 도구 | 없음 | 빠른 Python 프로젝트/스크립트 실행 관리 | `uv run python script.py` | `winget install --id astral-sh.uv -e` | [uv installation docs](https://docs.astral.sh/uv/getting-started/installation/) | standalone installer가 아니라면 `uv self update`는 비활성화됩니다 |
| `just` | task runner | `make`와 인접 | 여러 개발 명령의 깔끔한 진입점 | `just test` | `winget install --id Casey.Just -e` | [just programmer’s manual](https://just.systems/man/en/) | `make`와 함께 둘 수 있지만 대표 runner는 하나로 정하는 편이 좋습니다 |
| `curl` | HTTP 클라이언트 | `curl` | 안정적인 기본 HTTP 요청 도구 | `curl https://example.com` | 많은 Windows 시스템에 기본 포함 | [curl project](https://curl.se/) | PowerShell alias나 wrapper 기대치와 충돌하지 않게 baseline을 명확히 적어야 합니다 |
| `xh` | 읽기 좋은 HTTP 클라이언트 | 없음 | `curl`보다 사람이 API를 살펴보기 좋음 | `xh GET https://example.com` | `winget install --id ducaale.xh -e` | [xh project](https://github.com/ducaale/xh) | 기본값이라기보다 사람이 읽기 좋은 보조 도구로 두는 편이 좋습니다 |
| `pandoc` | 문서 변환 | 없음 | Markdown, HTML, 문서 포맷 변환의 핵심 도구 | `pandoc in.md -o out.html` | `winget install --id JohnMacFarlane.Pandoc -e` | [Pandoc](https://pandoc.org/) | 다른 셸 도구에 비해 무겁지만 포맷 변환 범위가 매우 넓습니다 |
| `difft` | 구조 인지 diff | 없음 | 줄 단위가 아닌 구문 중심 diff | `difft a.ts b.ts` | `winget install --id Wilfred.difftastic -e` | [difftastic](https://github.com/Wilfred/difftastic) | 실행 파일 이름은 `difft`입니다 |

## 강한 확장 도구

| 툴 | 효과 | 비고 |
| --- | --- | --- |
| `delta` | `git diff`를 읽기 좋게 만듦 | 기본 readable diff pager; `difft`와 함께 쓰면 구조적 diff까지 보완 |
| `hyperfine` | 셸 명령 벤치마크 | 도구 선택을 수치로 비교할 때 유용 |
| `watchexec` | 파일 변경 시 명령 재실행 | 반복적인 로컬 테스트에 유용 |
| `jc` | 명령 출력 → JSON 변환 | Windows/PowerShell 혼합 환경에서 특히 유용 |
| `fx` | JSON 인터랙티브 탐색 | `jq`가 과할 때 빠르게 구조 확인 가능 |
| `defuddle` | 웹페이지를 깔끔한 Markdown으로 추출 | 에이전트 친화적인 읽기 도구 |
| `direnv` | 디렉터리별 환경 변수 자동 로딩 | Windows에서는 주의 깊게 문서화할 가치가 큼 |
| `duckdb` | 로컬 파일을 SQL로 조회 | CSV, Parquet, JSON을 하나의 질의 모델로 다루기 좋음 |
| `sqlite-utils` | 로컬 데이터를 빠르게 SQLite로 정리 | 셸 출력이나 JSON을 질의 가능한 로컬 상태로 바꾸기 좋음 |
| `qsv` | 고성능 CSV 도구 | 표형 데이터가 커질수록 강함 |

## 선택 확장 후보

핵심 베이스라인에 꼭 필요한 것은 아니지만, 에이전트 친화 환경을 더 넓히고 싶다면 검토할 만한 후보들입니다.

| 툴 | 역할 | POSIX 대응 | 왜 의미가 있는가 | 권장 Windows 설치 | 공식/1차 출처 | 주의점 |
| --- | --- | --- | --- | --- | --- | --- |
| `tealdeer` | tldr 클라이언트 | 없음 | 브라우저를 열지 않고도 빠른 명령 예시를 볼 수 있음 | release binary 또는 `cargo install tealdeer` | [tealdeer](https://github.com/tealdeer-rs/tealdeer) | 내부 문서가 잘 정리돼 있다면 필수는 아님 |
| `duckdb` | 로컬 분석용 SQL CLI | 없음 | CSV, Parquet, JSON 같은 데이터를 하나의 질의 모델로 살펴보기 좋음 | `winget install DuckDB.cli` | [DuckDB install](https://duckdb.org/install/) | Windows에서는 Visual C++ Redistributable이 필요할 수 있음 |
| `sqlite-utils` | SQLite 자동화 CLI | 없음 | CSV나 JSON을 빠르게 질의 가능한 로컬 상태로 바꾸기 좋음 | `pipx install sqlite-utils` | [sqlite-utils installation](https://sqlite-utils.datasette.io/en/stable/installation.html) | Python 도구라서 실행 환경을 분명히 관리하는 편이 좋음 |
| `qsv` | 고성능 CSV 툴킷 | 없음 | 단순 원라이너로 다루기 어려운 표형 데이터에 강함 | release binary 또는 `cargo install qsv --locked --features all_features` | [qsv](https://github.com/dathere/qsv) | 기능 범위가 넓어서 핵심보다는 확장 후보로 두는 편이 좋음 |
| `broot` | 트리 탐색 | 부분적 `tree` / fuzzy browser 역할 | 대형 레포에서 디렉터리 구조를 빠르게 훑기 좋음 | release binary 또는 공식 설치 문서 경로 | [broot](https://github.com/Canop/broot) | 기계보다는 사람 쪽 체감이 더 큰 도구라 선택 설치가 적합 |
| `doggo` | DNS 클라이언트 | `dig` / `drill` 역할 | 별도 셸로 내려가지 않고도 DNS를 살펴보기 좋음 | release binary 또는 공식 설치 경로 | [doggo](https://github.com/mr-karan/doggo) | 네트워크 진단까지 이 환경에서 다루지 않으면 우선순위는 높지 않음 |
| `gron` | JSON 평탄화 | 없음 | 중첩 JSON을 grep-friendly한 대입 줄로 바꿔 줌 | release binary 또는 upstream의 `go install` 경로 | [gron](https://github.com/tomnomnom/gron) | `jq`, `fx`, `jc`만으로도 대부분 해결된다면 급하지 않음 |

## 대표 기본값

이 환경은 겹치는 역할마다 대표 명령 하나를 정합니다.

- 텍스트 검색 → `rg`
- 파일 찾기 → `fd`
- 파일 보기 → `bat`
- 디렉터리 listing → `eza`
- 디렉터리 점프 → `zoxide`
- Python 프로젝트 실행 → `uv`
- 프로젝트 task 실행 → `just`
- HTTP 요청 → `curl`
- JSON 보기/가공 → `jq`
- 문서 변환 → `pandoc`

대안 도구를 지울 필요는 없지만, 기본값은 분명해야 합니다.

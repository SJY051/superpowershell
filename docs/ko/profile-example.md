# 프로필 예시

이 문서는 부트스트랩이 만든 최소 스캐폴드를 실제로 커스터마이즈하면 어떤 모습이 되는지 보여줍니다.

## 파일 구조

```
Documents/PowerShell/
├── Microsoft.PowerShell_profile.ps1    # 로더
├── profile.d/
│   ├── 00-core.ps1                     # 환경 보정
│   ├── 10-modules.ps1                  # interactive 모듈 import
│   ├── 20-interactive.ps1              # PSReadLine 설정
│   ├── 22-local-cli-paths.ps1          # 추가 PATH 항목
│   ├── 25-tool-integrations.ps1        # direnv, fzf 등
│   ├── 30-aliases.ps1                  # POSIX 스타일 명령 대응
│   ├── 32-ls-eza.ps1                   # eza 기반 listing alias
│   ├── 33-cd-zoxide.ps1               # zoxide 인지 cd wrapper
│   ├── 35-terminal-tools.ps1           # 도구 레지스트리
│   └── 90-local.ps1                    # 장비별 오버라이드
└── AgentName.Exec_profile.ps1          # 에이전트 안전 서브셋
```

## 예시: `00-core.ps1`

```powershell
# XDG 디렉터리 보정
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path $HOME '.config' }
if (-not $env:XDG_CACHE_HOME)  { $env:XDG_CACHE_HOME  = Join-Path $HOME '.cache' }
if (-not $env:XDG_DATA_HOME)   { $env:XDG_DATA_HOME   = Join-Path $HOME '.local\share' }

# 안전한 PATH 추가 헬퍼
function Add-PathIfExists {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $parts = @($env:PATH -split ';' | Where-Object { $_ })
    if ($parts -contains $Path) { return }
    $env:PATH = ($parts + $Path) -join ';'
}

# 안전한 모듈 import 헬퍼
function Import-OptionalModule {
    param([string]$Name)
    try { Import-Module $Name -ErrorAction Stop }
    catch { Write-Verbose "Optional module not available: $Name" }
}

# which 동등 함수
function which { param([string]$Name) (Get-Command $Name -ErrorAction SilentlyContinue).Source }
```

## 예시: `30-aliases.ps1`

```powershell
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat -Option AllScope
}
if (Get-Command fd -ErrorAction SilentlyContinue) {
    Set-Alias find fd -Option AllScope
}
if (Get-Command rg -ErrorAction SilentlyContinue) {
    Set-Alias grep rg -Option AllScope
}
```

## 예시: `32-ls-eza.ps1`

```powershell
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls  { eza --icons --group-directories-first @args }
    function la  { eza --icons --group-directories-first -a @args }
    function ll  { eza --icons --group-directories-first -l @args }
    function lla { eza --icons --group-directories-first -la @args }
    function lt  { eza --icons --group-directories-first -l --sort=modified @args }
    function tree { eza --icons --tree @args }
}
```

## 예시: `33-cd-zoxide.ps1`

```powershell
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })

    function cd {
        param([string]$Path)
        if (-not $Path -or $Path -eq '~') { Set-Location $HOME; return }
        if ($Path -eq '-') { Set-Location -; return }
        if ($Path -eq '..') { Set-Location ..; return }
        if (Test-Path -LiteralPath $Path) { Set-Location $Path; return }
        # 퍼지 매칭은 zoxide에 위임
        z $Path
    }
}
```

## 예시: 에이전트 Exec 프로필

별도 파일 (예: `AgentName.Exec_profile.ps1`)로 안전한 서브셋만 불러옵니다.

```powershell
$profileDir = Join-Path $HOME 'Documents\PowerShell\profile.d'
$safeModules = @(
    '00-core.ps1',
    '22-local-cli-paths.ps1',
    '25-tool-integrations.ps1',
    '30-aliases.ps1',
    '32-ls-eza.ps1',
    '35-terminal-tools.ps1'
)

foreach ($name in $safeModules) {
    $path = Join-Path $profileDir $name
    if (Test-Path -LiteralPath $path) { . $path }
}
```

제외되는 것:

- `10-modules.ps1` — 프롬프트 테마, `posh-git`, `Terminal-Icons`
- `20-interactive.ps1` — `PSReadLine` 키바인딩과 예측
- `33-cd-zoxide.ps1` — interactive 퍼지 매칭 (에이전트에 유용하면 포함 가능)
- `90-local.ps1` — 자동화에 안전하지 않을 수 있는 장비별 오버라이드

## 핵심 패턴

1. **각 파일이 자기 의존성을 스스로 확인** — alias나 통합 전에 명령 존재 여부를 체크
2. **번호 접두사가 로드 순서를 제어** — 알파벳 순이 아니라 의도된 우선순위
3. **에이전트 프로필은 엄격한 서브셋** — interactive 프로필의 상위 집합이 되면 안 됨
4. **대체 동작은 조용히** — 도구가 없으면 소음 없이 건너뜀

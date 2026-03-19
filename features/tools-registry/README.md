# Tools Registry Feature

An optional installable PowerShell feature that provides `tools` and `tools-add` from a configurable inventory directory.

선택적으로 설치할 수 있는 PowerShell 기능으로, 설정 가능한 인벤토리 디렉터리에서 `tools`와 `tools-add` 명령을 제공합니다.

## What It Does

- reads tool inventory data from `terminal-tools.json`
- reads manual overrides from `manual-tools.json`
- merges both into one public-facing registry
- exposes:
  - `tools`
  - `tools-add`

- `terminal-tools.json`에서 도구 인벤토리를 읽고
- `manual-tools.json`에서 수동 오버레이를 읽은 뒤
- 둘을 하나의 공개형 레지스트리로 합치고
- 다음 명령을 제공합니다.
  - `tools`
  - `tools-add`

## Default Inventory Location

By default, the feature uses:

```text
%USERPROFILE%\.terminal-tools
```

You can override this with:

```powershell
$env:TERMINAL_TOOLS_HOME = 'D:\somewhere\terminal-tools'
```

## Included Files

- `tools-registry.ps1` - the profile fragment / helper implementation
- `install.ps1` - preview-first installer
- `manual-tools.example.json` - minimal example data

## Install

Preview first:

```powershell
pwsh -NoLogo -NoProfile -File .\features\tools-registry\install.ps1 -WhatIf
```

Apply:

```powershell
pwsh -NoLogo -NoProfile -File .\features\tools-registry\install.ps1 -Apply
```

If you also want the installer to append a loader snippet to your PowerShell profile:

```powershell
pwsh -NoLogo -NoProfile -File .\features\tools-registry\install.ps1 -Apply -AddToProfile
```

## Usage

After dot-sourcing or loading the installed fragment:

```powershell
tools
tools -Category data
tools -Grouped
tools -Detailed
tools -Json
tools -PreferredOnly

tools-add jq -Category data -Description "JSON processor" -Preferred -Replaces jq
```

## Expected Input Shape

Both `terminal-tools.json` and `manual-tools.json` may contain entries like this:

```json
[
  {
    "name": "jq",
    "category": "data",
    "description": "JSON processor",
    "available_in": ["powershell", "pwsh"],
    "command_types": ["application"],
    "preferred": true,
    "replaces": [],
    "posix_analogue": "jq",
    "tags": ["json", "data"],
    "notes": "Representative JSON filter"
  }
]
```

## Notes

- `tools-add` writes only to `manual-tools.json`
- if `terminal-tools.json` is missing, the feature still works with manual entries only
- this feature does not scan the machine by itself; it only reads inventory files

- `tools-add`는 `manual-tools.json`만 수정합니다
- `terminal-tools.json`이 없어도 수동 항목만으로 동작합니다
- 이 기능 자체는 시스템 전체를 스캔하지 않고, 이미 존재하는 인벤토리 파일만 읽습니다

---
name: "git-on-windows"
description: "Use when an agent uses git on Windows and needs to handle line endings, credential management, long paths, and other Windows-specific git configuration."
---

# Git on Windows

English summary:
Use this skill when an agent uses git on Windows and needs to avoid platform-specific pitfalls.

한국어 요약:
이 스킬은 에이전트가 Windows에서 git을 사용할 때, 플랫폼 고유의 함정을 피하도록 돕습니다.

## Use This Skill When

- cloning or initializing a repository on Windows
- seeing unexpected line-ending changes in diffs
- git commands fail with path-too-long errors
- setting up authentication or credential storage
- collaborating on repos shared between Windows and Unix systems

## Core Rules

1. Always use `git.exe` explicitly if there's any chance of alias collision.
2. Configure `core.autocrlf` deliberately — don't leave it at the system default without understanding what it does.
3. Enable long paths if the project has deep directory structures.
4. Use Git Credential Manager (included with Git for Windows) for authentication.
5. Use forward slashes in `.gitignore` and path arguments — git normalizes them.

## Essential Configuration

### Line endings
```powershell
# Recommended for Windows in cross-platform projects:
# Check out as CRLF, commit as LF:
git config --global core.autocrlf true

# If the project is Windows-only:
git config --global core.autocrlf false

# Better: use .gitattributes in the repo (per-project, portable):
# * text=auto
# *.sh text eol=lf
# *.bat text eol=crlf
# *.png binary
```

### Long paths
```powershell
# Enable long path support in git:
git config --global core.longpaths true

# Also needs Windows-level support (admin, one-time):
# Registry: HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled = 1
# Or via Group Policy: Computer Configuration > Administrative Templates >
#   System > Filesystem > Enable Win32 long paths
```

### Credential management
```powershell
# Git Credential Manager (default with Git for Windows):
git config --global credential.helper manager

# Verify it's working:
git credential-manager --version

# For specific hosts (e.g., GitHub with token):
# GCM handles this interactively on first push/pull.
```

### Default branch
```powershell
git config --global init.defaultBranch main
```

## Common Pitfalls

### Line ending noise in diffs
```powershell
# If you see every line changed but content looks the same:
git diff --stat
# Likely a CRLF/LF mismatch.

# Quick check:
git diff --word-diff  # Shows actual content changes only

# Fix: normalize line endings
echo "* text=auto" > .gitattributes
git add --renormalize .
git commit -m "Normalize line endings"
```

### Path too long
```
error: unable to create file very/deep/nested/path/to/file.ts: Filename too long
```
```powershell
# Fix:
git config --global core.longpaths true
# Then re-clone or checkout.
```

### `git.exe` vs Git Bash vs WSL git
```powershell
# Prefer git.exe from PowerShell:
& git.exe status

# Check which git you're running:
Get-Command git | Select-Object Source

# Avoid: running WSL git on Windows paths (path translation issues)
# Avoid: mixing Git Bash and PowerShell git in the same repo
```

### SSH vs HTTPS
```powershell
# Check current remote URL:
git remote get-url origin

# Switch to HTTPS (works with GCM):
git remote set-url origin https://github.com/user/repo.git

# Switch to SSH (needs ssh key setup):
git remote set-url origin git@github.com:user/repo.git

# SSH key location on Windows:
# C:/Users/<user>/.ssh/id_ed25519
```

### Permissions and executable bit
```powershell
# Windows doesn't have Unix file permissions.
# Git tracks the executable bit, but Windows ignores it.

# If you need to mark a file as executable (for CI/Linux):
git update-index --chmod=+x script.sh

# Check what git thinks:
git ls-files -s script.sh
```

## Output From This Skill

When using this skill, state:

- what line-ending strategy is in use (autocrlf / .gitattributes)
- whether long paths are enabled
- what credential helper is configured
- any platform-specific risks for the current operation

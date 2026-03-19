---
name: "process-port-inspection"
description: "Use when an agent needs to find what is using a port, inspect running processes, or manage services on Windows."
---

# Process & Port Inspection

English summary:
Use this skill when an agent needs to inspect processes, check ports, or manage services on Windows.

한국어 요약:
이 스킬은 에이전트가 Windows에서 프로세스 확인, 포트 점검, 서비스 관리를 수행할 때 사용합니다.

## Use This Skill When

- a dev server won't start because the port is occupied
- the agent needs to find or kill a specific process
- checking whether a service is running before depending on it
- diagnosing resource usage (CPU, memory)

## Core Rules

1. Prefer PowerShell-native cmdlets over legacy tools when available.
2. Use `Get-NetTCPConnection` instead of `netstat` — it returns objects, not text.
3. Use `Stop-Process` instead of `taskkill` — it integrates with PowerShell's pipeline.
4. Some operations require **admin elevation**. State this clearly before attempting.
5. Always confirm the target before killing processes — especially in shared environments.

## Patterns

### What's using this port?
```powershell
# Find process on port 3000:
$conn = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($conn) {
    $proc = Get-Process -Id $conn.OwningProcess
    $proc | Select-Object Id, ProcessName, Path
} else {
    Write-Output "Port 3000 is free."
}
```

### Find a process by name
```powershell
Get-Process -Name "node" -ErrorAction SilentlyContinue |
    Select-Object Id, ProcessName, CPU, WorkingSet64
```

### Kill a process
```powershell
# By ID (safest):
Stop-Process -Id 12345 -Force

# By name (kills ALL matching — use carefully):
Stop-Process -Name "node" -Force

# Kill process tree (parent + children):
function Stop-ProcessTree {
    param([int]$Id)
    Get-CimInstance Win32_Process |
        Where-Object { $_.ParentProcessId -eq $Id } |
        ForEach-Object { Stop-ProcessTree -Id $_.ProcessId }
    Stop-Process -Id $Id -Force -ErrorAction SilentlyContinue
}
```

### List all listening ports
```powershell
Get-NetTCPConnection -State Listen |
    Select-Object LocalPort, OwningProcess,
        @{Name='ProcessName'; Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} |
    Sort-Object LocalPort
```

### Check if a service is running
```powershell
$svc = Get-Service -Name "sshd" -ErrorAction SilentlyContinue
if ($svc -and $svc.Status -eq 'Running') {
    Write-Output "SSH server is running."
} else {
    Write-Output "SSH server is not running."
}
```

### Start/stop a service (requires admin)
```powershell
# Start:
Start-Service -Name "sshd"

# Stop:
Stop-Service -Name "sshd" -Force
```

## Legacy Equivalents

| Task | Legacy (text output) | PowerShell (object output) |
|---|---|---|
| List ports | `netstat -ano` | `Get-NetTCPConnection` |
| Kill process | `taskkill /PID 1234 /F` | `Stop-Process -Id 1234 -Force` |
| Find process | `tasklist /FI "IMAGENAME eq node.exe"` | `Get-Process -Name node` |
| Service status | `sc query sshd` | `Get-Service -Name sshd` |

The legacy commands still work and are fine for quick one-offs, but PowerShell cmdlets return objects that pipe cleanly into `ConvertTo-Json`, `Where-Object`, and `Select-Object`.

## Output From This Skill

When using this skill, state:

- what you are looking for (port, process name, service)
- whether admin elevation is needed
- whether you intend to kill/stop anything (confirm first)
- what the result means for the next step

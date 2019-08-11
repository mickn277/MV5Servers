# Powershell

### Template
```powershell
# --------------------------------------------------------------------------------
# Usage:
#
# Purpose:
# 
# Requirements:
# 
# History:
#
# TODO:
#
# --------------------------------------------------------------------------------

# -------------------- Configuration ---------------------------------------------
# -------------------- Includes --------------------------------------------------
# -------------------- Private Constants -----------------------------------------

#$CurrentDir = (Split-Path $MyInvocation.PSCommandPath)
$CurrentDir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ScriptName = ((Split-Path -Leaf $MyInvocation.MyCommand.Path).Split([string[]]@(".")))[0]

Write-Host $CurrentDir $ScriptName

# -------------------- Private Variables -----------------------------------------
# -------------------- Private Routines ------------------------------------------
# -------------------- Public Routines -------------------------------------------
# -------------------- Unit Tests ------------------------------------------------
# -------------------- Main ------------------------------------------------------
```

### Commands
```powershell
# Nohup a job.  This achieves parallelism.
Start-Job { & C:\Full\Path\To\my.exe }

```
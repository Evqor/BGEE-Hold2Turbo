#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook true

; BGEE-Hold2Turbo v1.0-1
; Hold a mouse side button while Baldur's Gate: Enhanced Edition is active
; to temporarily switch Cheat Engine Speedhack to turbo speed.
;
; Required one-time Cheat Engine hotkey setup:
;   Ctrl + Alt + Shift + 1 => Speedhack 2.0x
;   Ctrl + Alt + Shift + 2 => Speedhack 1.0x
;
; Place BGEE-Hold2Turbo.ct in the same folder as this script.

; =========================
; User settings
; =========================

gameExeCandidates := [
    "Baldur.exe",
    "Baldur64.exe"
]

ctPath := A_ScriptDir "\BGEE-Hold2Turbo.ct"

; Set this manually if auto-detection fails.
; Example:
; ceExe := "C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe"
ceExe := ""

; Default side mouse button: XButton1.
; Change every XButton1 / XButton1 Up hotkey near the bottom if you want XButton2.
turboOnHotkey := "^!+1"   ; Ctrl + Alt + Shift + 1
turboOffHotkey := "^!+2"  ; Ctrl + Alt + Shift + 2

watchIntervalMs := 1000
showTrayTips := true

; =========================
; Internal state
; =========================

turboHeld := false
ctLaunchedForCurrentRun := false
lastGamePid := 0
resolvedCeExe := ResolveCheatEnginePath(ceExe)

if !FileExist(ctPath) {
    TrayTip "CT file not found:`n" ctPath, "BGEE-Hold2Turbo", 5
}

if resolvedCeExe = "" {
    TrayTip "Cheat Engine was not found. Edit ceExe in the AHK script.", "BGEE-Hold2Turbo", 7
}

SetTimer WatchBGEE, watchIntervalMs
OnExit ResetSpeedOnExit

WatchBGEE() {
    global gameExeCandidates, ctPath, resolvedCeExe
    global ctLaunchedForCurrentRun, lastGamePid, turboHeld, turboOffHotkey, showTrayTips

    pid := FindProcess(gameExeCandidates)

    if pid {
        if turboHeld && !IsBGEEActive() {
            Send turboOffHotkey
            turboHeld := false
        }

        if pid != lastGamePid {
            lastGamePid := pid
            ctLaunchedForCurrentRun := false
        }

        if !ctLaunchedForCurrentRun && FileExist(ctPath) && resolvedCeExe != "" {
            Run '"' resolvedCeExe '" "' ctPath '"', , "Min"
            ctLaunchedForCurrentRun := true
            if showTrayTips {
                TrayTip "BGEE detected. Cheat Engine table opened.", "BGEE-Hold2Turbo", 3
            }
        }
    } else {
        if turboHeld {
            Send turboOffHotkey
            turboHeld := false
        }
        lastGamePid := 0
        ctLaunchedForCurrentRun := false
    }
}

FindProcess(exeNames) {
    for exeName in exeNames {
        pid := ProcessExist(exeName)
        if pid {
            return pid
        }
    }
    return 0
}

IsBGEEActive() {
    global gameExeCandidates
    for exeName in gameExeCandidates {
        if WinActive("ahk_exe " exeName) {
            return true
        }
    }
    return false
}

ResolveCheatEnginePath(manualPath) {
    if manualPath != "" && FileExist(manualPath) {
        return manualPath
    }

    candidates := [
        A_ProgramFiles "\Cheat Engine 7.6\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.5\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.4\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.6\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine 7.5\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine 7.4\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine\cheatengine.exe"
    ]

    for path in candidates {
        if FileExist(path) {
            return path
        }
    }

    return ""
}

ResetSpeedOnExit(*) {
    global turboHeld, turboOffHotkey
    if turboHeld {
        Send turboOffHotkey
    }
}

#HotIf IsBGEEActive()

XButton1::
{
    global turboHeld, turboOnHotkey
    if !turboHeld {
        turboHeld := true
        Send turboOnHotkey
    }
}

XButton1 Up::
{
    global turboHeld, turboOffHotkey
    if turboHeld {
        turboHeld := false
        Send turboOffHotkey
    }
}

#HotIf

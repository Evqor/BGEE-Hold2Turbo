#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook true

; BGEE-Hold2Turbo
; Hold a mouse side button while Baldur's Gate: Enhanced Edition is active
; to temporarily enable Cheat Engine Speedhack turbo speed.
;
; Required one-time Cheat Engine hotkey setup:
;   F9 => Speedhack 2.0x with "Stop on release" enabled
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

; Cheat Engine Speedhack hotkey.
; Configure this key in Cheat Engine as:
;   Speed: 2.0
;   Stop on release: enabled
; F9 is recommended because it avoids modifier-key state issues.
turboKey := "F9"

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
OnExit ResetTurboKeyOnExit

WatchBGEE() {
    global gameExeCandidates, ctPath, resolvedCeExe
    global ctLaunchedForCurrentRun, lastGamePid, turboHeld, turboKey, showTrayTips

    pid := FindProcess(gameExeCandidates)

    if pid {
        if turboHeld && !IsBGEEActive() {
            ReleaseTurboKey()
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
            ReleaseTurboKey()
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

PressTurboKey() {
    global turboHeld, turboKey
    if !turboHeld {
        turboHeld := true
        Send "{" turboKey " down}"
    }
}

ReleaseTurboKey() {
    global turboHeld, turboKey
    if turboHeld {
        turboHeld := false
        Send "{" turboKey " up}"
    }
}

ResetTurboKeyOnExit(*) {
    ReleaseTurboKey()
}

#HotIf IsBGEEActive()

XButton1::
{
    PressTurboKey()
}

XButton1 Up::
{
    ReleaseTurboKey()
}

#HotIf

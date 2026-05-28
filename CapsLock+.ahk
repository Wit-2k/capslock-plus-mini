#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#UseHook

; capslock-plus-mini entry point.
; This branch keeps the AHK v2 core hotkey layer and excludes the original GUI modules.

if VerCompare(A_AhkVersion, "2.0") < 0 {
    MsgBox("CapsLock+ migration branch requires AutoHotkey v2. Please launch this script with AutoHotkey v2.", "CapsLock+", "Iconx")
    ExitApp()
}

; The script needs elevated privileges to intercept shortcuts consistently.
fullCommandLine := DllCall("GetCommandLine", "str")
if !(A_IsAdmin || RegExMatch(fullCommandLine, " /restart(?!\S)")) {
    try {
        if A_IsCompiled
            Run('*RunAs "' A_ScriptFullPath '" /restart')
        else
            Run('*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"')
    }
    ExitApp()
}

if FileExist("capslock+icon.ico")
    TraySetIcon("capslock+icon.ico", , true)

SetStoreCapsLockMode(false)
ProcessSetPriority("High")

global cClipboardAll := ""
global caClipboardAll := ""
global sClipboardAll := ""
global allowRunOnClipboardChange := true
global CapsLockActive := false
global CapsLockWasUsed := false
global keyset := Map()
global CLSets := Map()
global settingsModifyTime := ""
global startupNoticeGui := ""
global startupNoticeText := ""
global startupNoticeFrame := 0

#Include lib\lib_v2_language.ahk
#Include lib\lib_v2_functions.ahk
#Include lib\lib_v2_settings.ahk
#Include lib\lib_v2_keysSet.ahk
#Include lib\lib_v2_keysFunction.ahk

; Keep the startup notice non-interactive and close it as soon as initialization ends.
ShowStartupNotice()
try {
    InitAll()
} finally {
    CloseStartupNotice()
}

InitAll() {
    global
    Suspend(true)
    InitLanguage()
    SettingsInit()
    KeysInit()
    OnClipboardChange(HandleClipboardChange)
    SetTimer(MonitorSettingsFile, 500)
    Suspend(false)
}

ShowStartupNotice() {
    global startupNoticeGui, startupNoticeText, startupNoticeFrame
    startupNoticeFrame := 0
    startupNoticeGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20", "capslock-plus-mini")
    startupNoticeGui.BackColor := "20242c"
    startupNoticeGui.MarginX := 18
    startupNoticeGui.MarginY := 14
    startupNoticeGui.SetFont("s10 cFFFFFF", "Segoe UI")
    startupNoticeGui.AddText("w220 Center", "capslock-plus-mini")
    startupNoticeGui.SetFont("s9 cB8C0CC", "Segoe UI")
    startupNoticeText := startupNoticeGui.AddText("w220 Center y+6", "Starting")
    startupNoticeGui.Show("AutoSize Center NoActivate")
    UpdateStartupNotice()
    SetTimer(UpdateStartupNotice, 120)
}

UpdateStartupNotice() {
    global startupNoticeText, startupNoticeFrame
    if !IsObject(startupNoticeText)
        return
    dots := ["", ".", "..", "..."]
    startupNoticeFrame := Mod(startupNoticeFrame + 1, 4)
    startupNoticeText.Text := "Starting" dots[startupNoticeFrame + 1]
}

CloseStartupNotice() {
    global startupNoticeGui, startupNoticeText
    SetTimer(UpdateStartupNotice, 0)
    if IsObject(startupNoticeGui)
        startupNoticeGui.Destroy()
    startupNoticeGui := ""
    startupNoticeText := ""
}

CapsLock::
{
    global CapsLockActive, CapsLockWasUsed
    CapsLockActive := true
    CapsLockWasUsed := true
    SetTimer(ClearCapsLockWasUsed, -300)

    KeyWait("CapsLock")
    CapsLockActive := false

    if CapsLockWasUsed {
        if GetKeyBinding("press_caps")
            RunFunc(GetKeyBinding("press_caps"))
        else
            SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
    }
    CapsLockWasUsed := false
}

<!CapsLock::
#CapsLock::
{
    global CapsLockActive
    CapsLockActive := true
    KeyWait("CapsLock")
    CapsLockActive := false
}

ClearCapsLockWasUsed() {
    global CapsLockWasUsed
    CapsLockWasUsed := false
}

HandleClipboardChange(clipboardType) {
    global allowRunOnClipboardChange, CapsLockActive
    if allowRunOnClipboardChange && !CapsLockActive && GetSetting("Global", "allowClipboard", "1") != "0" {
        try {
            ClipSaver("s")
        } catch {
            Sleep(100)
            ClipSaver("s")
        }
    }
    allowRunOnClipboardChange := true
}

#HotIf GetSetting("Global", "allowClipboard", "1") != "0"
$^v::
{
    try KeyFunc_pasteSystem()
}
#HotIf

#HotIf GetKeyState("CapsLock", "P")
*LAlt::Return

; Wildcard hotkeys let the same dispatcher handle plain CapsLock and CapsLock+LAlt.
*WheelUp::
{
    HandleCapsKey("wheelup")
}

*WheelDown::
{
    HandleCapsKey("wheeldown")
}

*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
*1::
*2::
*3::
*4::
*5::
*6::
*7::
*8::
*9::
*0::
*F1::
*F2::
*F3::
*F4::
*F5::
*F6::
*F7::
*F8::
*F9::
*F10::
*F11::
*F12::
*Space::
*Tab::
*Enter::
*Esc::
*BackSpace::
*RAlt::
{
    HandleCapsKey(NormalizeHotkeyName(A_ThisHotkey))
}

*`::
{
    HandleCapsKey("backquote")
}

*-::
{
    HandleCapsKey("minus")
}

*=::
{
    HandleCapsKey("equal")
}

*[::
{
    HandleCapsKey("leftsquarebracket")
}

*]::
{
    HandleCapsKey("rightsquarebracket")
}

*\::
{
    HandleCapsKey("backslash")
}

*`;::
{
    HandleCapsKey("semicolon")
}

*'::
{
    HandleCapsKey("quote")
}

*,::
{
    HandleCapsKey("comma")
}

*.::
{
    HandleCapsKey("dot")
}

*/::
{
    HandleCapsKey("slash")
}

#1::
#2::
#3::
#4::
#5::
#6::
#7::
#8::
#9::
#0::
{
    keyName := NormalizeHotkeyName(RegExReplace(A_ThisHotkey, "^#"))
    HandleCapsKey("win_" keyName)
}
#HotIf

HandleCapsKey(keyName) {
    global CapsLockWasUsed
    keyName := NormalizeHotkeyName(keyName)
    ; Modifiers are detected at dispatch time so wildcard keys can share one handler.
    if !RegExMatch(keyName, "^(lalt|win)_") {
        if GetKeyState("LAlt", "P")
            keyName := "lalt_" keyName
        else if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
            keyName := "win_" keyName
    }
    try RunFunc(GetKeyBinding("caps_" keyName))
    CapsLockWasUsed := false
}

NormalizeHotkeyName(keyName) {
    keyName := StrLower(keyName)
    keyName := RegExReplace(keyName, "^[*~$<>!^+#]+")
    replacements := Map(
        "backspace", "backspace",
        "escape", "esc",
        "esc", "esc",
        "space", "space",
        "tab", "tab",
        "enter", "enter",
        "ralt", "ralt",
        "wheelup", "wheelup",
        "wheeldown", "wheeldown"
    )
    return replacements.Has(keyName) ? replacements[keyName] : keyName
}

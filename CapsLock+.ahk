#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#UseHook

; CapsLock+ v2 migration bootstrap.
; Phase 1 intentionally loads only v2-safe modules. Legacy v1 modules remain in
; the repository and will be migrated back into the include graph in later phases.

if VerCompare(A_AhkVersion, "2.0") < 0 {
    MsgBox("CapsLock+ migration branch requires AutoHotkey v2. Please launch this script with AutoHotkey v2.", "CapsLock+", "Iconx")
    ExitApp()
}

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

global CLversion := "Version: 3.3.0.0-v2-bootstrap | 2026-05-28`n`nCopyright Junkai Chen"
global cClipboardAll := ""
global caClipboardAll := ""
global sClipboardAll := ""
global whichClipboardNow := 0
global allowRunOnClipboardChange := true
global ctrlZ := false
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
    global ctrlZ, CapsLockActive, CapsLockWasUsed, keyset
    ctrlZ := true
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
    global allowRunOnClipboardChange, CapsLockActive, CLSets, whichClipboardNow
    if allowRunOnClipboardChange && !CapsLockActive && GetSetting("Global", "allowClipboard", "1") != "0" {
        try {
            ClipSaver("s")
        } catch {
            Sleep(100)
            ClipSaver("s")
        }
        whichClipboardNow := 0
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

<!a::
<!b::
<!c::
<!d::
<!e::
<!f::
<!g::
<!h::
<!i::
<!j::
<!k::
<!l::
<!m::
<!n::
<!o::
<!p::
<!q::
<!r::
<!s::
<!t::
<!u::
<!v::
<!w::
<!x::
<!y::
<!z::
<!1::
<!2::
<!3::
<!4::
<!5::
<!6::
<!7::
<!8::
<!9::
<!0::
<!F1::
<!F2::
<!F3::
<!F4::
<!F5::
<!F6::
<!F7::
<!F8::
<!F9::
<!F10::
<!F11::
<!F12::
<!Space::
<!Tab::
<!Enter::
<!BackSpace::
<!RAlt::
{
    keyName := NormalizeHotkeyName(RegExReplace(A_ThisHotkey, "^<!"))
    HandleCapsKey("lalt_" keyName)
}

<!`::
{
    HandleCapsKey("lalt_backquote")
}

<!-::
{
    HandleCapsKey("lalt_minus")
}

<!=::
{
    HandleCapsKey("lalt_equal")
}

<![::
{
    HandleCapsKey("lalt_leftsquarebracket")
}

<!]::
{
    HandleCapsKey("lalt_rightsquarebracket")
}

<!\::
{
    HandleCapsKey("lalt_backslash")
}

<!`;::
{
    HandleCapsKey("lalt_semicolon")
}

<!'::
{
    HandleCapsKey("lalt_quote")
}

<!,::
{
    HandleCapsKey("lalt_comma")
}

<!.::
{
    HandleCapsKey("lalt_dot")
}

<!/::
{
    HandleCapsKey("lalt_slash")
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
    if !RegExMatch(keyName, "^(lalt|win)_") && GetKeyState("LAlt", "P")
        keyName := "lalt_" keyName
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

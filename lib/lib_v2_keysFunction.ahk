global winBindings := Map()

keyFunc_doNothing() {
}

keyFunc_test() {
    MsgBox("testing", , "T1")
}

keyFunc_send(text) {
    Send(text)
}

keyFunc_run(target) {
    Run(target)
}

keyFunc_toggleCapsLock() {
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

keyFunc_reload() {
    Reload()
}

keyFunc_openCpasDocs() {
    Run("https://capslox.com/capslock-plus/")
}

keyFunc_moveLeft(i := 1) {
    Send("{Left " i "}")
}

keyFunc_moveRight(i := 1) {
    Send("{Right " i "}")
}

keyFunc_moveUp(i := 1) {
    Send("{Up " i "}")
}

keyFunc_moveDown(i := 1) {
    Send("{Down " i "}")
}

keyFunc_moveWordLeft(i := 1) {
    Send("^{Left " i "}")
}

keyFunc_moveWordRight(i := 1) {
    Send("^{Right " i "}")
}

keyFunc_backspace() {
    Send("{Backspace}")
}

keyFunc_delete() {
    Send("{Delete}")
}

keyFunc_deleteAll() {
    Send("^a{Delete}")
}

keyFunc_deleteWord() {
    Send("+^{Left}{Delete}")
}

keyFunc_forwardDeleteWord() {
    Send("+^{Right}{Delete}")
}

keyFunc_end() {
    Send("{End}")
}

keyFunc_home() {
    Send("{Home}")
}

keyFunc_moveToPageBeginning() {
    Send("^{Home}")
}

keyFunc_moveToPageEnd() {
    Send("^{End}")
}

keyFunc_deleteLine() {
    Send("{End}+{Home}{Backspace}")
}

keyFunc_deleteToLineBeginning() {
    Send("+{Home}{Backspace}")
}

keyFunc_deleteToLineEnd() {
    Send("+{End}{Backspace}")
}

keyFunc_deleteToPageBeginning() {
    Send("+^{Home}{Backspace}")
}

keyFunc_deleteToPageEnd() {
    Send("+^{End}{Backspace}")
}

keyFunc_enterWherever() {
    Send("{End}{Enter}")
}

keyFunc_esc() {
    Send("{Esc}")
}

keyFunc_enter() {
    Send("{Enter}")
}

keyFunc_selectLeft(i := 1) {
    Send("+{Left " i "}")
}

keyFunc_selectRight(i := 1) {
    Send("+{Right " i "}")
}

keyFunc_selectUp(i := 1) {
    Send("+{Up " i "}")
}

keyFunc_selectDown(i := 1) {
    Send("+{Down " i "}")
}

keyFunc_selectWordLeft(i := 1) {
    Send("+^{Left " i "}")
}

keyFunc_selectWordRight(i := 1) {
    Send("+^{Right " i "}")
}

keyFunc_selectHome() {
    Send("+{Home}")
}

keyFunc_selectEnd() {
    Send("+{End}")
}

keyFunc_selectToPageBeginning() {
    Send("+^{Home}")
}

keyFunc_selectToPageEnd() {
    Send("+^{End}")
}

keyFunc_selectCurrentWord() {
    Send("^{Left}+^{Right}")
}

keyFunc_selectCurrentLine() {
    Send("{Home}+{End}")
}

keyFunc_pageUp() {
    Send("{PgUp}")
}

keyFunc_pageDown() {
    Send("{PgDn}")
}

keyFunc_jumpPageTop() {
    Send("^{Home}")
}

keyFunc_jumpPageBottom() {
    Send("^{End}")
}

keyFunc_copy_1() {
    CopyToSlot("c", false, true)
}

keyFunc_cut_1() {
    CopyToSlot("c", true, true)
}

keyFunc_paste_1() {
    global cClipboardAll
    PasteSlot(cClipboardAll)
}

keyFunc_copy_2() {
    CopyToSlot("ca", false, true)
}

keyFunc_cut_2() {
    CopyToSlot("ca", true, true)
}

keyFunc_paste_2() {
    global caClipboardAll
    PasteSlot(caClipboardAll)
}

keyFunc_pasteSystem() {
    global sClipboardAll
    if IsObject(sClipboardAll)
        PasteSlot(sClipboardAll)
    else
        Send("^v")
}

keyFunc_switchClipboard() {
    global whichClipboardNow
    whichClipboardNow := Mod(whichClipboardNow + 1, 3)
    ShowMsg("clipboard: " whichClipboardNow, 1000)
}

CopyToSlot(slotName, cut := false, fallbackToLine := false) {
    global allowRunOnClipboardChange, whichClipboardNow
    oldClipboard := ClipboardAll()
    A_Clipboard := ""
    allowRunOnClipboardChange := false
    Send(cut ? "^x" : "^{Insert}")
    copied := ClipWait(0.15)

    if !copied && fallbackToLine {
        A_Clipboard := ""
        Send(cut ? "{Home}+{End}^x" : "{Home}+{End}^{Insert}{End}")
        copied := ClipWait(0.15)
    }

    if copied {
        ClipSaver(slotName)
        whichClipboardNow := slotName = "c" ? 1 : 2
    }
    A_Clipboard := oldClipboard
}

PasteSlot(clipData) {
    if !IsObject(clipData) {
        ShowMsg("clipboard slot is empty", 1000)
        return
    }
    oldClipboard := ClipboardAll()
    A_Clipboard := clipData
    Sleep(30)
    Send("^v")
    Sleep(50)
    A_Clipboard := oldClipboard
}

keyFunc_mouseSpeedIncrease() {
    mouseSpeed := Integer(GetSetting("Global", "mouseSpeed", "10")) + 1
    if mouseSpeed > 20
        mouseSpeed := 20
    SetSettings("Global", "mouseSpeed", mouseSpeed)
    ShowMsg("mouse speed: " mouseSpeed, 1000)
}

keyFunc_mouseSpeedDecrease() {
    mouseSpeed := Integer(GetSetting("Global", "mouseSpeed", "10")) - 1
    if mouseSpeed < 1
        mouseSpeed := 1
    SetSettings("Global", "mouseSpeed", mouseSpeed)
    ShowMsg("mouse speed: " mouseSpeed, 1000)
}

keyFunc_winPin() {
    try WinSetAlwaysOnTop(-1, "A")
}

keyFunc_winTransparent() {
    try {
        current := WinGetTransparent("A")
        if current = "" || current = 255
            WinSetTransparent(180, "A")
        else
            WinSetTransparent("Off", "A")
    }
}

keyFunc_winbind_binding(slot) {
    global winBindings
    slot := String(slot)
    hwnd := WinExist("A")
    if hwnd {
        winBindings[slot] := hwnd
        ShowMsg("bound window " slot, 1000)
    }
}

keyFunc_winbind_activate(slot) {
    global winBindings
    slot := String(slot)
    if winBindings.Has(slot) && WinExist("ahk_id " winBindings[slot]) {
        WinActivate("ahk_id " winBindings[slot])
    } else {
        ShowMsg("no bound window " slot, 1000)
    }
}

keyFunc_undoRedo() {
    global ctrlZ
    if ctrlZ {
        Send("^z")
        ctrlZ := false
    } else {
        Send("^y")
        ctrlZ := true
    }
}

keyFunc_doubleChar(left, right := "") {
    if right = ""
        right := left
    SendText(left right)
    Send("{Left " StrLen(right) "}")
}

keyFunc_doubleAngle() {
    keyFunc_doubleChar("<", ">")
}

keyFunc_send_dot() {
    Send(".")
}

keyFunc_mediaNext() {
    Send("{Media_Next}")
}

keyFunc_translate() {
    WarnUnavailable("Translation")
}

keyFunc_mathBoard() {
    WarnUnavailable("Math Board")
}

keyFunc_getJSEvalString() {
    WarnUnavailable("JavaScript evaluation")
}

keyFunc_tabScript() {
    WarnUnavailable("CapsLock+Tab")
}

keyFunc_qbar() {
    WarnUnavailable("qbar")
}

keyFunc_qbar_upperFolderPath() {
    WarnUnavailable("qbar folder navigation")
}

keyFunc_qbar_lowerFolderPath() {
    WarnUnavailable("qbar folder navigation")
}

keyFunc_activateSideWin(direction) {
    WarnUnavailable("side-window activation")
}

keyFunc_clearWinMinimizeStach() {
    WarnUnavailable("window minimize stack")
}

keyFunc_pushWinMinimizeStack() {
    WarnUnavailable("window minimize stack")
}

keyFunc_unshiftWinMinimizeStack() {
    WarnUnavailable("window minimize stack")
}

keyFunc_popWinMinimizeStack() {
    WarnUnavailable("window minimize stack")
}

keyFunc_tabNext() {
    Send("^{Tab}")
}

keyFunc_tabPrve() {
    Send("^+{Tab}")
}

keyFunc_putWinToBottom() {
    try WinMoveBottom("A")
}

keyFunc_pageMoveLineDown(count := 1) {
    Send("{Down " count "}")
}

keyFunc_pageMoveLineUp(count := 1) {
    Send("{Up " count "}")
}

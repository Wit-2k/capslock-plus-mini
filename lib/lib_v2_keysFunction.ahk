global winBindings := Map()

; Public key functions. Only functions with the keyFunc_ prefix can be bound from [Keys].

keyFunc_doNothing() {
}

; Small helpers for user-defined key bindings.
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

; Cursor movement.
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

; Deletion helpers.
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

; Selection helpers.
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

; Two independent CapsLock clipboard slots.
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

CopyToSlot(slotName, cut := false, fallbackToLine := false) {
    global allowRunOnClipboardChange
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

; Minimal non-GUI window helpers.
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
    slot := slot ""
    hwnd := WinExist("A")
    if hwnd {
        winBindings[slot] := hwnd
        ShowMsg("bound window " slot, 1000)
    }
}

keyFunc_winbind_activate(slot) {
    global winBindings
    slot := slot ""
    if winBindings.Has(slot) && WinExist("ahk_id " winBindings[slot]) {
        WinActivate("ahk_id " winBindings[slot])
    } else {
        ShowMsg("no bound window " slot, 1000)
    }
}

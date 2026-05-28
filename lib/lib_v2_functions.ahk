; Shared helpers for the AHK v2 mini runtime.

; Show short non-blocking feedback without stealing focus.
ShowMsg(msg, timeout := 2000) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), -Abs(timeout))
}

; Store a full clipboard payload in one of the script-managed slots.
ClipSaver(clipName) {
    global cClipboardAll, caClipboardAll, sClipboardAll
    if clipName = "s"
        sClipboardAll := ClipboardAll()
    else if clipName = "c"
        cClipboardAll := ClipboardAll()
    else
        caClipboardAll := ClipboardAll()
}

; Dispatch a [Keys] value such as keyFunc_moveRight or keyFunc_moveRight(5).
RunFunc(funcSpec) {
    funcSpec := Trim(funcSpec)
    if !funcSpec
        return

    if !RegExMatch(funcSpec, "^\s*([A-Za-z_]\w*)(?:\((.*)\))?\s*$", &match) {
        ShowMsg("Invalid key function: " funcSpec)
        return
    }

    funcName := match[1]
    paramText := match[2]
    params := paramText ? ParseFuncParams(paramText) : []

    try {
        %funcName%(params*)
    } catch as err {
        if InStr(err.Message, "nonexistent function")
            ShowMsg("Unavailable key function: " funcName)
        else
            ShowMsg("Key function failed: " funcName " - " err.Message)
    }
}

; Split simple comma-separated parameters while preserving quoted commas.
ParseFuncParams(paramText) {
    params := []
    current := ""
    quote := ""
    i := 1
    while i <= StrLen(paramText) {
        ch := SubStr(paramText, i, 1)
        if quote {
            if ch = quote {
                quote := ""
            } else if ch = "\" && i < StrLen(paramText) {
                i += 1
                current .= SubStr(paramText, i, 1)
            } else {
                current .= ch
            }
        } else if ch = Chr(34) || ch = "'" {
            quote := ch
        } else if ch = "," {
            params.Push(CleanFuncParam(current))
            current := ""
        } else {
            current .= ch
        }
        i += 1
    }
    params.Push(CleanFuncParam(current))
    return params
}

CleanFuncParam(value) {
    value := Trim(value)
    if StrLen(value) >= 2 {
        first := SubStr(value, 1, 1)
        last := SubStr(value, -1)
        if (first = Chr(34) && last = Chr(34)) || (first = "'" && last = "'")
            return SubStr(value, 2, StrLen(value) - 2)
    }
    return value
}

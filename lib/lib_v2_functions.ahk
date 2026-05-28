GetSelText() {
    oldClipboard := ClipboardAll()
    A_Clipboard := ""
    Send("^{Insert}")
    if ClipWait(0.15) {
        selText := A_Clipboard
        A_Clipboard := oldClipboard
        if selText && SubStr(selText, -1) != "`n"
            return selText
    }
    A_Clipboard := oldClipboard
    return ""
}

UTF8encode(str) {
    bytes := Buffer(StrPut(str, "UTF-8"))
    StrPut(str, bytes, "UTF-8")
    encoded := ""
    loop bytes.Size - 1 {
        encoded .= "%" Format("{:02X}", NumGet(bytes, A_Index - 1, "UChar"))
    }
    return encoded
}

URLencode(str) {
    static from := ["!", "#", "$", "&", "'", "(", ")", "*", "+", ",", ":", ";", "=", "?", "@", "[", "]"]
    static to := ["%21", "%23", "%24", "%26", "%27", "%28", "%29", "%2A", "%2B", "%2C", "%3A", "%3B", "%3D", "%3F", "%40", "%5B", "%5D"]
    for index, search in from
        str := StrReplace(str, search, to[index])
    return str
}

SetSettingsValue(section, key, value) {
    SetSettings(section, key, value)
}

ShowMsg(msg, timeout := 2000) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), -Abs(timeout))
}

ClipSaver(clipName) {
    global cClipboardAll, caClipboardAll, sClipboardAll
    if clipName = "s"
        sClipboardAll := ClipboardAll()
    else if clipName = "c"
        cClipboardAll := ClipboardAll()
    else
        caClipboardAll := ClipboardAll()
}

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

WarnUnavailable(featureName) {
    ShowMsg(featureName " is not migrated to AutoHotkey v2 yet.", 2000)
}

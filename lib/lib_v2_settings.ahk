; Runtime settings loader.
; The mini edition reads only [Global] and [Keys] from CapsLock+settings.ini.

SettingsInit() {
    global settingsModifyTime
    EnsureSettingsFiles()
    LoadSettings()
    try settingsModifyTime := FileGetTime("CapsLock+settings.ini", "M")
}

; Create ignored runtime INI files when the user runs the script for the first time.
EnsureSettingsFiles() {
    global lang_settingsFileContent, lang_settingsDemoFileContent

    if !FileExist("CapsLock+settingsDemo.ini") {
        FileAppend(lang_settingsDemoFileContent, "CapsLock+settingsDemo.ini", "UTF-16")
        try FileSetAttrib("+R", "CapsLock+settingsDemo.ini")
    }

    if !FileExist("CapsLock+settings.ini")
        FileAppend(lang_settingsFileContent, "CapsLock+settings.ini", "UTF-16")
}

; Parse INI content into maps. [Keys] accepts only keyFunc_* values for safety.
LoadSettings() {
    global CLSets
    sections := ["Global", "Keys"]
    CLSets := Map()
    for section in sections
        CLSets[section] := Map()

    if !FileExist("CapsLock+settings.ini")
        return

    content := FileRead("CapsLock+settings.ini")
    currentSection := ""
    loop parse content, "`n", "`r" {
        line := Trim(A_LoopField)
        if !line || SubStr(line, 1, 1) = ";"
            continue

        if RegExMatch(line, "^\[(.+)\]$", &sectionMatch) {
            currentSection := sectionMatch[1]
            if !CLSets.Has(currentSection)
                CLSets[currentSection] := Map()
            continue
        }

        if !currentSection
            continue

        eqPos := InStr(line, "=")
        if !eqPos
            continue

        key := Trim(SubStr(line, 1, eqPos - 1))
        value := Trim(SubStr(line, eqPos + 1), " `t")
        if !key
            continue

        if currentSection = "Keys" {
            if RegExMatch(value, "i)^keyFunc_")
                CLSets[currentSection][NormalizeSettingKey(key)] := value
        } else {
            CLSets[currentSection][key] := value
        }
    }
}

; Lightweight live reload for manual edits to CapsLock+settings.ini.
MonitorSettingsFile() {
    global settingsModifyTime
    if !FileExist("CapsLock+settings.ini")
        return

    latestModifyTime := FileGetTime("CapsLock+settings.ini", "M")
    if latestModifyTime != settingsModifyTime {
        settingsModifyTime := latestModifyTime
        LoadSettings()
        KeysInit()
    }
}

GetSetting(section, key, defaultValue := "") {
    global CLSets
    if CLSets.Has(section) && CLSets[section].Has(key)
        return CLSets[section][key]
    return defaultValue
}

; Write one setting and refresh the in-memory maps immediately.
SetSettings(section, key, value) {
    IniWrite(value, "CapsLock+settings.ini", section, key)
    LoadSettings()
    KeysInit()
}

GetKeyBinding(keyName) {
    global keyset
    keyName := NormalizeSettingKey(keyName)
    return keyset.Has(keyName) ? keyset[keyName] : ""
}

SetDefaultKey(keyName, funcSpec) {
    global keyset
    keyName := NormalizeSettingKey(keyName)
    if !keyset.Has(keyName) || !keyset[keyName]
        keyset[keyName] := funcSpec
}

NormalizeSettingKey(keyName) {
    return StrLower(Trim(keyName))
}

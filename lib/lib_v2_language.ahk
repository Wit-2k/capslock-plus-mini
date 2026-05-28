; Minimal language support for generated settings files.

InitLanguage() {
    global lang_settingsFileContent, lang_settingsDemoFileContent

    if IsLangChinese() {
        lang_settingsFileContent := ";------------ Encoding: UTF-16 ------------`r`n;请对照 CapsLock+settingsDemo.ini 来配置相关设置`r`n[Global]`r`nallowClipboard=1`r`n`r`n[Keys]`r`n"
        lang_settingsDemoFileContent := ";------------ Encoding: UTF-16 ------------`r`n; # capslock-plus-mini 设置样本`r`n[Global]`r`nallowClipboard=1`r`n`r`n[Keys]`r`n; caps_f7=keyFunc_doNothing`r`n; caps_lalt_f=keyFunc_moveRight(10)`r`n"
    } else {
        lang_settingsFileContent := ";------------ Encoding: UTF-16 ------------`r`n; Please refer to CapsLock+settingsDemo.ini to configure settings`r`n[Global]`r`nallowClipboard=1`r`n`r`n[Keys]`r`n"
        lang_settingsDemoFileContent := ";------------ Encoding: UTF-16 ------------`r`n; # capslock-plus-mini settings demo`r`n[Global]`r`nallowClipboard=1`r`n`r`n[Keys]`r`n; caps_f7=keyFunc_doNothing`r`n; caps_lalt_f=keyFunc_moveRight(10)`r`n"
    }
}

; Prefer the Windows locale, then fall back to AHK's language code.
GetSystemLanguage() {
    languageMap := Map(
        "0404", "Chinese_Taiwan",
        "0804", "Chinese_PRC",
        "0c04", "Chinese_Hong_Kong",
        "1004", "Chinese_Singapore",
        "1404", "Chinese_Macau",
        "0409", "English_United_States",
        "0809", "English_United_Kingdom"
    )

    try {
        systemLocale := RegRead("HKEY_CURRENT_USER\Control Panel\International", "Locale")
        if systemLocale
            systemLocale := SubStr(systemLocale, -3)
        if languageMap.Has(systemLocale)
            return languageMap[systemLocale]
    }

    return languageMap.Has(A_Language) ? languageMap[A_Language] : "English_United_States"
}

IsLangChinese() {
    return InStr(GetSystemLanguage(), "Chinese") > 0
}

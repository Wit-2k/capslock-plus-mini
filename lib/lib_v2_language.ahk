InitLanguage() {
    global lang_bw_noWIRini, lang_clq_noCmd, lang_clq_emptyFolder
    global lang_yd_name, lang_yd_translating, lang_yd_needKey, lang_yd_errorNoNet
    global lang_yd_errorNoResults, lang_settingsFileContent, lang_settingsDemoFileContent

    if IsLangChinese() {
        lang_bw_noWIRini := "CapsLock+winsInfosRecorder.ini 不存在"
        lang_clq_noCmd := "没有该命令"
        lang_clq_emptyFolder := "<空文件夹>"
        lang_yd_name := "有道翻译"
        lang_yd_translating := "翻译中..."
        lang_yd_needKey := "缺少有道翻译API的key，有道翻译无法使用"
        lang_yd_errorNoNet := "发送异常，可能是网络已断开"
        lang_yd_errorNoResults := "无词典结果"
        lang_settingsFileContent := ";------------ Encoding: UTF-16 ------------`r`n;请对照 CapsLock+settingsDemo.ini 来配置相关设置`r`n[Global]`r`nallowClipboard=1`r`ndefault_hotkey_scheme=capslox`r`nmouseSpeed=10`r`n`r`n[Keys]`r`n"
        lang_settingsDemoFileContent := ";------------ Encoding: UTF-16 ------------`r`n; # CapsLock+ v2 设置样本`r`n[Global]`r`nautostart=0`r`nallowClipboard=1`r`ndefault_hotkey_scheme=capslox`r`nloadingAnimation=0`r`nmouseSpeed=10`r`n`r`n[Keys]`r`n; caps_f7=keyFunc_example2`r`n"
    } else {
        lang_bw_noWIRini := "CapsLock+winsInfosRecorder.ini does not exist"
        lang_clq_noCmd := "No such command"
        lang_clq_emptyFolder := "<Empty folder>"
        lang_yd_name := "Youdao Translation"
        lang_yd_translating := "Translating..."
        lang_yd_needKey := "Youdao translator cannot be used without the key of Youdao translation API"
        lang_yd_errorNoNet := "Failed to send, maybe the network is disconnected"
        lang_yd_errorNoResults := "No result"
        lang_settingsFileContent := ";------------ Encoding: UTF-16 ------------`r`n; Please refer to CapsLock+settingsDemo.ini to configure settings`r`n[Global]`r`nallowClipboard=1`r`ndefault_hotkey_scheme=capslox`r`nmouseSpeed=10`r`n`r`n[Keys]`r`n"
        lang_settingsDemoFileContent := ";------------ Encoding: UTF-16 ------------`r`n; # CapsLock+ v2 settings demo`r`n[Global]`r`nautostart=0`r`nallowClipboard=1`r`ndefault_hotkey_scheme=capslox`r`nloadingAnimation=0`r`nmouseSpeed=10`r`n`r`n[Keys]`r`n; caps_f7=keyFunc_example2`r`n"
    }
}

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

IsLangChinaChinese() {
    return GetSystemLanguage() = "Chinese_PRC"
}



CheckKeyStatus(filePath, statusControl, dateControl) {
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/fisher.txt, %A_Temp%\d3d91.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/miner.txt, %A_Temp%\d3d92.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/zavod.txt, %A_Temp%\d3d93.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/fsin.txt, %A_Temp%\d3d94.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/fix.txt, %A_Temp%\d3d95.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/sport.txt, %A_Temp%\d3d96.txt
    URLDownloadToFile, https://raw.githubusercontent.com/KituhasWHCS/onlykeys/main/sporttp.txt, %A_Temp%\d3d97.txt
    ; Получаем ключ с ПК
    strComputer := "."
    objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . strComputer . "\root\cimv2")
    colSettings := objWMIService.ExecQuery("Select * from Win32_OperatingSystem")._NewEnum
    While colSettings[objOSItem]
    {
        Key := objOSItem.SerialNumber
    }

    ; Читаем файл и проверяем ключ
    FileRead, fileContent, %filePath%
    keyFound := false
    Loop, Parse, fileContent, `n, `r
    {
        line := StrSplit(A_LoopField, " ")
        if (line[1] = Key)
        {
            keyFound := true
            keyDate := line[2]
            break
        }
    }

    ; Проверяем дату
    if (keyFound)
    {
        ; Преобразуем дату из файла в формат yyyyMMdd
        dateParts := StrSplit(keyDate, ".")
        keyDateFormatted := dateParts[3] dateParts[2] dateParts[1]

        FormatTime, today, , yyyyMMdd
        if (keyDateFormatted < today)
        {
            status := "Не активирован"
            GuiControl, +cRed, %statusControl%
        }
        else
        {
            status := "Активирован"
            GuiControl, +cGreen, %statusControl%
        }
        date := keyDate
    }
    else
    {
        status := "Не активирован"
        date := "Нет ключа на сервере"
        GuiControl, +cRed, %statusControl%
    }

    GuiControl,, %statusControl%, %status%
    GuiControl,, %dateControl%, %date%
}



CheckKeyStatus(filePath, statusControl, dateControl) {
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

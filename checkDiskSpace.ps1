$DePC = "<hostname here please>"

 

 

foreach($k in get-WmiObject win32_logicaldisk -Computername $DePC){

    if($k.DeviceID -eq "C:"){

        $free = [Math]::Round($k.FreeSpace / ([Math]::Pow(1024,3)),3)

        $size = [Math]::Round($k.Size / ([Math]::Pow(1024,3)),3)

        $strOut = "Er is nog " + $free + " GB vrij van de " + $size + " GB."

       

    }

}

$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName $DePC).LastBootupTime

$strOut += " En heeft " + $uptime.Days + " dagen en " + $uptime.Hours + " uur uptime"

echo $strOut

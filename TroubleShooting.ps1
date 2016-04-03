<<<<<<< HEAD
﻿#https://technet.microsoft.com/en-us/library/hh849682.aspx


Get-WinEvent -ListLog * -ComputerName NJ1AD1.mathematica.net |Where-Object {$_.RecordCount}


$s = "NJ1DEVC" #, "Server02", "Server03"
Foreach ($Server in $S) {$Server; Get-WinEvent -ListLog "Windows PowerShell" -Computername $Server}



=======
﻿#https://technet.microsoft.com/en-us/library/hh849682.aspx


Get-WinEvent -ListLog * -ComputerName NJ1AD1.mathematica.net |Where-Object {$_.RecordCount}


$s = "NJ1DEVC" #, "Server02", "Server03"
Foreach ($Server in $S) {$Server; Get-WinEvent -ListLog "Windows PowerShell" -Computername $Server}



>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708

#https://technet.microsoft.com/en-us/library/hh849682.aspx


Get-WinEvent -ListLog * -ComputerName NJ1AD1.mathematica.net |Where-Object {$_.RecordCount}


$s = "NJ1DEVC" #, "Server02", "Server03"
Foreach ($Server in $S) {$Server; Get-WinEvent -ListLog "Windows PowerShell" -Computername $Server}




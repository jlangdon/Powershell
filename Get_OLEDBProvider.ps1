<<<<<<< HEAD
﻿#Get_OLEDBProvider
#Remote to server

Enter-PSSession -ComputerName NJ1DEVC 

(New-Object system.data.oledb.oledbenumerator).GetElements() | select SOURCES_NAME, SOURCES_DESCRIPTION | Sort-Object -Property Sources_Name | Format-Table -Autosize

Exit-PSSession
=======
﻿#Get_OLEDBProvider
#Remote to server

Enter-PSSession -ComputerName NJ1DEVC 

(New-Object system.data.oledb.oledbenumerator).GetElements() | select SOURCES_NAME, SOURCES_DESCRIPTION | Sort-Object -Property Sources_Name | Format-Table -Autosize

Exit-PSSession
>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708

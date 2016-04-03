#Get_OLEDBProvider
#Remote to server

Enter-PSSession -ComputerName NJ1DEVC 

(New-Object system.data.oledb.oledbenumerator).GetElements() | select SOURCES_NAME, SOURCES_DESCRIPTION | Sort-Object -Property Sources_Name | Format-Table -Autosize

Exit-PSSession

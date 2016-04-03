<<<<<<< HEAD
﻿#Send-Email

try
{
    
    $params = @{'To'='jlangdon@mathematica-mpr.com'
    'From'='jlangdon@mathematica-mpr.com'
    'Subject'='DeltekTE Remove Backup File Removal'
    'Body'='Can I send from my machine.'
    'SMTPServer'='smtp.mathematica-mpr.com'}
     Send-MailMessage @params


}
	catch
	{
		Write-Output = "Exception: $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())"
			
	} 



#$From = "YourEmail@gmail.com"
#$To = "AnotherEmail@YourDomain.com"
#$Cc = "YourBoss@YourDomain.com"
#$Attachment = "C:\temp\Some random file.txt"
#$Subject = "Email Subject"
#$Body = "Insert body text here"
#$SMTPServer = "smtp.gmail.com"
#$SMTPPort = "587"
#
#Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject `
#-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
#-Credential (Get-Credential) -Attachments $Attachment
=======
﻿#Send-Email

try
{
    
    $params = @{'To'='jlangdon@mathematica-mpr.com'
    'From'='jlangdon@mathematica-mpr.com'
    'Subject'='DeltekTE Remove Backup File Removal'
    'Body'='Can I send from my machine.'
    'SMTPServer'='smtp.mathematica-mpr.com'}
     Send-MailMessage @params


}
	catch
	{
		Write-Output = "Exception: $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())"
			
	} 



#$From = "YourEmail@gmail.com"
#$To = "AnotherEmail@YourDomain.com"
#$Cc = "YourBoss@YourDomain.com"
#$Attachment = "C:\temp\Some random file.txt"
#$Subject = "Email Subject"
#$Body = "Insert body text here"
#$SMTPServer = "smtp.gmail.com"
#$SMTPPort = "587"
#
#Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject `
#-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
#-Credential (Get-Credential) -Attachments $Attachment
>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708

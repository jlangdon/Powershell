#Write-Verbose 'Producing final HTML'
#Write-Verbose 'Pipe this output to a file to save it'
#ConvertTo-HTML -Head $head -PostContent $frag1,$frag2 `
#-PreContent "<h1>Hardware Inventory for $ComputerName</h1>" |
#Out-File report.htm
#Write-Verbose "Sending e-mail"



$params = @{'To'='jeffreylangdon@outlook.com'
'From'='PSAlert@mathematica-mpr.com'
'Body'='The $Server Service is no longer responding'
'Subject'='$Server service offline'
'SMTPServer'='intrelay.mathematica-mpr.com'}
Send-MailMessage @params
#PowerShell Gallery Commands
#https://mcpmag.com/articles/2015/10/15/exploring-the-powershell-gallery.aspx


<#

Find-Module -Name Posh* | Out-GridView -PassThru


Find-Module -Name Posh* | Out-GridView -PassThru  |  Save-Module -Path C:\temp -Verbose

Find-Module poshrsjob  -AllVersions |  Out-GridView -PassThru  | Install-Module -Verbose


#>

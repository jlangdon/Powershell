#Break statement added to stop you from accidentally running all the functions by clicking 'Run Script' or hitting F5
Write-Host 'Stop hitting F5'
break
$env:PSModulePath -split ";"
$env:PSModulePath = $envPSModulePath -replace "c:\\Poweshell\Modules"
$psISE.Options.ShowToolBar=$True
#Get Module info
Get-module dbatools 
(Get-Module -ListAvailable dbatools).path
#Install Module
Install-module dbatools -AllowClobber
#List module functions
Get-Command -Module dbatools
#Import Module
Remove-Module dbatools
#View function definition
(Get-Command Test-DbaConnection).Definition

Get-ChildItem Cert:\CurrentUser\TrustedPublisher | Select-Object *
New-DbaComputerCertificate | Set-DbaNetworkCertificate -SqlInstance Jeffrey\SQL2017

#Get-Command -Name New-Database  | Select-Object-ExpandProperty Definition

#Find all instances on a computer
Find-DbaInstance -ComputerName localhost

#Get database Info
Get-SqlDatabase -Name AdventureWorks2002


#Test Connnection
Test-DbaConnection -SqlInstance Jeffrey\SQL2017
$Credential = Get-Credential sa

#Test-DbaConnection
#Disable Encryption check
Set-DbatoolsConfig -Name Import.EncryptionMessageCheck -Value $false -PassThru | Register-DbatoolsConfig
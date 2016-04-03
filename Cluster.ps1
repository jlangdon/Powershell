/* Run as administrator or you will get an error */

get-command *cluster*


get-command g*cluster*

Get-Cluster

Get-ClusterGroup
Get-ClusterGroup "Cluster Group" | Get-ClusterResource

Get-ClusterNode

Get-ClusterResource

<#
Remove-ClusterResource -Name 'SQL Network Name (NJ1DEVC)' -Force 
Remove-ClusterResource -Name 'SQL Server' -Force 
Remove-ClusterResource -Name 'SQL Server FILESTREAM share (MSSQLSERVER)' -Force 

Remove-ClusterResource -Name 'SQL14DEVC_DATA' -Force
Remove-ClusterResource -Name 'SQL14DEVC_LOG' -Force
Remove-ClusterResource -Name 'SQL14DEVC_MP' -Force
Remove-ClusterResource -Name 'SQL14DEVC_SYSTEM' -Force
Remove-ClusterResource -Name 'SQL14DEVC_TempDB' -Force

Add-ClusterResource -Name 'SQL14DEVC_MP'

Add-ClusterResource

Get-ClusterOwnerNode

Get-ClusterQuorum

Get-ClusterSharedVolume

Get-ClusterSharedVolumeState -Name 'NJ1SQL14DEVC'

get-help Get-ClusterSharedVolumeState -Full

Get-Command –Module FailoverClusters

Get-ClusterLog -UseLocalTime

Add-ClusterResourceType "SQL Server Agent" C:\Windows\system32\SQAGTRES.DLL

#>
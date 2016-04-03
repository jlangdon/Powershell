<<<<<<< HEAD
﻿Import-Module -Name 'SQLPS' -DisableNameChecking
$instance = "JLANGDON\MSSQLSERVER2012"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
$dbName = "AdventureWorks2012"
$db = $server.Databases[$dbName]
$Query = "SELECT * FROM Person.Person"
=======
﻿Import-Module -Name 'SQLPS' -DisableNameChecking
$instance = "JLANGDON\MSSQLSERVER2012"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
$dbName = "AdventureWorks2012"
$db = $server.Databases[$dbName]
$Query = "SELECT * FROM Person.Person"
>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
Invoke-Sqlcmd –ServerInstance $instance –Database $db.name –Query $query | Select FirstName, LastName, ModifiedDate | Format-Table -AutoSize
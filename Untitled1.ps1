

$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') "JLANGDON\MSSQLSERVER2012"

$databasename = "AdventureWorks2012"

$database = $orgsrv.Databases[$databasename]

$tablename = "Person.Person"

$table = $database.Tables[$tablename]



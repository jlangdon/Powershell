<<<<<<< HEAD
﻿

$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') "JLANGDON\MSSQLSERVER2012"

$databasename = "AdventureWorks2012"

$database = $orgsrv.Databases[$databasename]

$tablename = "Person.Person"

$table = $database.Tables[$tablename]


=======
﻿

$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') "JLANGDON\MSSQLSERVER2012"

$databasename = "AdventureWorks2012"

$database = $orgsrv.Databases[$databasename]

$tablename = "Person.Person"

$table = $database.Tables[$tablename]


>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708

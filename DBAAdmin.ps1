#Import SQLPS Module
Import-Module SQLPS -DisableNameChecking
#View Directories
#DIR
# Change to sql drive
cd sql
#choose local server name
cd jlangdon
#choose instance
cd MSSQLSERVER2012
#view objects
DIR
#choose databases
cd databases
#view databases
dir
cd SQLSERVER:\sql\jlangdon\MSSQLSERVER2012\
#Set path to parent directory
Set-Location -Path .. -PassThru

Get-ChildItem -Path "Databases" | Where Name -Like "Adventure*"

#Import SQLPS Module
Import-Module SQLPS -DisableNameChecking
#View Directories
#DIR
# Change to sql drive
cd sql
#choose local server name
cd jlangdon
#choose instance
cd MSSQLSERVER2012
#view objects
DIR
#choose databases
cd databases
#view databases
dir
cd SQLSERVER:\sql\jlangdon\MSSQLSERVER2012\
#Set path to parent directory
Set-Location -Path .. -PassThru























#For SQL Server 2008 R2 and SQL Server 2008

#add-type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.SMOExtended, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.SqlEnum, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.Management.Sdk.Sfc, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
# 
#
#For SQL Server 2012
#
#add-type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.Smo, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.SMOExtended, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.SqlEnum, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
#
#add-type -AssemblyName "Microsoft.SqlServer.Management.Sdk.Sfc, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop


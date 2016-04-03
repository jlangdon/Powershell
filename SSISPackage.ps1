Add-Type -AssemblyName "Microsoft.SqlServer.ManagedDTS, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 

$ssisApplication = New-Object "Microsoft.SqlServer.Dts.Runtime.Application" 

$ssisPackagePath = "C:\SSIS\EnvironDemo1.dtsx" 

$ssisPackage = $ssisApplication.LoadPackage($ssisPackagePath,$null) 

$ssisPackage | Get-Member

$ssisPackage.Parameters.Add()

Get-Help -Full $ssisPackage


$TheVariableOption = PackageOption -Name "\Package.Variables[User::TheVariable].Properties[Value]" -Value "some thing";
&dtexec /File "$package" /Set $TheVariableOption;


$ssisPackage.Execute()  


#EnvironDemo1

Microsoft.SqlServer.Dts.RunTime.Variables myVars = package.Variables;

myVars["MyVariable1"].Value = "value1";
myVars["MyVariable2"].Value = "value2";

Microsoft.SqlServer.Dts.Runtime.DTSExecResult results = package.Execute(null, myVars, null, null, null)
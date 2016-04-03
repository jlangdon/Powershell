Setspn -l NJ1DEVCSVC  -- Lists SPNs for service account

Setspn -x --- Lists duplicate SPN

Setspn -S Pre 2012 which would check for duplicates before adding.  Now you use -A

Setspn -Q  Search for a specific

setspn -A MSSQLSvc/NJ1SQL14DEVC Mathematica\NJ1DEVCSVC
setspn -A MSSQLSvc/NJ1SQL14DEVC.mathematica.net:1433 Mathematica\NJ1DEVCSVC


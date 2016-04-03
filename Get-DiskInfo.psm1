function Get-DiskInfo {
[CmdletBinding()]
param(
[Parameter(Mandatory=$True,
ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True)]
[string[]]$computerName,
[Parameter(Mandatory=$True)]
[ValidateRange(10,90)]
[int]$threshold
)
BEGIN {}
PROCESS {
    foreach ($computer in $computername) {
        $params = @{computername=$computer
        filter="drivetype=3"
        class="win32_logicaldisk"}
        $disks = Get-WmiObject @params
            foreach ($disk in $disks) {
            $danger = $False
            if ($disk.freespace / $disk.size * 100 -le $threshold) {
            $danger = $True
            }
            $props = @{ComputerName=$computer
            Size=$disk.size / 1GB -as [int]
            Free = $disk.freespace / 1GB -as [int]
            Danger=$danger}
            $obj = New-Object –TypeName PSObject –Property $props
            $obj
            }
        }
}
END {}
}
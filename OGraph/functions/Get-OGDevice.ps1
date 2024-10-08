<#
.SYNOPSIS
List all devices in the organization.

.DESCRIPTION
List all devices in the organization.

Permissions: https://learn.microsoft.com/en-us/graph/api/device-list?view=graph-rest-1.0&tabs=http


.EXAMPLE
Get-OGDevice

.NOTES
General notes
#>
function Get-OGDevice {

    [CmdletBinding()]

    $uri = "/$GraphVersion/devices"
    Get-OGNextPage -uri $uri

}
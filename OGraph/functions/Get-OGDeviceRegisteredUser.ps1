<#
.SYNOPSIS
Retrieve a list of users that are registered users of the device

.DESCRIPTION
Retrieve a list of users that are registered users of the device.

For cloud joined devices and registered personal devices, registered users are set to the same value as registered owners at the time of registration.

Permissions: https://learn.microsoft.com/en-us/graph/api/device-list-registeredusers?view=graph-rest-1.0&tabs=http

.EXAMPLE
Get-OGDeviceRegisteredUser -DeviceEntraId 036j9cw6-9fa4-410c-83d8-6e3f3b2c7684

.NOTES
General notes
#>
function Get-OGDeviceRegisteredUser {

    [CmdletBinding()]
    param (
        # The Entra Object Id of the device. NOTE: This is not the device id.
        [Parameter(Mandatory = $true)]
        [string]$DeviceEntraId
    )

    $uri = "/$GraphVersion/devices/$DeviceEntraId/registeredUsers"
    Get-OGNextPage -uri $uri

}
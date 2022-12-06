<#
.SYNOPSIS
Get the license skus applied by a group

.DESCRIPTION
Gets the license skus applied by a group and any disabled service plans of those skus

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.EXAMPLE
Get-OGGroupLicense -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicense {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$GroupId
    )
    $URI = "/$GraphVersion/groups/$GroupId/assignedLicenses"
    Get-OGNextPage -uri $URI

}
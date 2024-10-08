<#
.SYNOPSIS
Get group site information using an Object ID.
.DESCRIPTION
Get group site information using an Object ID.

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group

.EXAMPLE
Get a group by Object ID
Get-OGGroupSite -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroupSite {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        $GroupId

    )

    $URI = "/$GraphVersion/groups/$($GroupId)/sites/root"
    get-ognextpage -uri $uri
}
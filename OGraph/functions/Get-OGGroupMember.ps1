<#
.SYNOPSIS
Get Members of a Group in Azure AD

.DESCRIPTION
Get Members of a Group in Azure AD

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group

.EXAMPLE
Get-OGGroupMember -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroupMember
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$GroupId
    )
    $URI = "/$GraphVersion/groups/$GroupId/members"
    Get-OGNextPage -uri $URI

}
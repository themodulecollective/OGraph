<#
.SYNOPSIS
Get group drive from Microsoft Graph
.DESCRIPTION
Get group drive using Group Object ID

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group

.EXAMPLE
Get a group drive by Object ID
Get-OGGroupDrive -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

    GroupID              : 3175b598-0fa0-4002-aebf-bfbf759c94a7
    DriveName            : Documents
    DriveURL             : https://contoso.sharepoint.com/teams/contosoteam/Shared%20Documents
    DriveID              : b!-RIj2DuyvEyV1T4NlOaMHk8XkS_I8MdFlUCq1BlcjgmhRfAj3-Z8RY2VpuvV_tpd
    driveType            : documentLibrary
    SiteURL              : https://contoso.sharepoint.com/teams/contosoteam
    createdDateTime      : 10/24/2022 05:12:09 AM
    lastModifiedDateTime : 11/21/2022 02:37:01 PM
    quotaTotal           : 1073741824000
    quotaUsed            : 1479181
    quotaRemaining       : 1479181
    quotaDeleted         : 0
    quotaState           : normal

#>
Function Get-OGGroupDrive
{
    [CmdletBinding()]
    param (

        [Parameter()]
        [guid]$GroupId
        ,
        [Parameter()]
        [string[]]$Property

    )

    $Property = @(

    )

    $URI = "/$GraphVersion/groups/$($GroupId)/drive/"

    $Result =  get-ognextpage -uri $uri

    $Result | Select-Object -Property @{n='GroupID'; e={$GroupId}},
    @{n='DriveName'; e={$_.name}},
    @{n='DriveURL'; e={$_.webUrl}},
    @{n='DriveID'; e={$_.id}},
    'driveType',
    @{n='SiteURL'; e={$_.webUrl.substring(0, $_.weburl.LastIndexOf('/'))}},
    'createdDateTime',
    'lastModifiedDateTime',
    @{n='quotaTotal'; e={$_.quota.total}},
    @{n='quotaUsed'; e={$_.quota.used}},
    @{n='quotaRemaining'; e={$_.quota.used}},
    @{n='quotaDeleted'; e={$_.quota.Deleted}},
    @{n='quotaState'; e={$_.quota.state}}

}
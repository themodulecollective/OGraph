<#
.SYNOPSIS
Get user OneDrive Meta information

.DESCRIPTION
Get user OneDrive Meta information

Permissions: https://learn.microsoft.com/en-us/graph/api/drive-get?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Userprincipalname or ID for lookup

.EXAMPLE
Get-OGUserDrive -userprincipalname test.user@domain.com
.NOTES
General notes
#>
Function Get-OGUserDrive {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName
    )
    $URI = "/$GraphVersion/users/$userprincipalname/drive"
    Get-OGNextPage -uri $URI
}
<#
.SYNOPSIS
List Calendars for a user or specify a users calendar with the calendars guid.

.DESCRIPTION
List Calendars for a user or specify a users calendar with the calendars guid.

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-calendars?view=graph-rest-1.0&tabs=http

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER SearchDisplayName
Parameter description

.PARAMETER All
Parameter description

.EXAMPLE
Get-OGCalendar -UserPrincipalName jdoe@contoso.com

.NOTES
General notes
#>
Function Get-OGCalendar {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName,
        [Parameter(Mandatory = $false)]$Id
    )
    if (-not [string]::IsNullOrWhiteSpace($id)) {
        $URI = "/$GraphVersion/users/$UserPrincipalName/calendars/$id"
        Get-OGNextPage -uri $URI
    }
    else {
        $URI = "/$GraphVersion/users/$UserPrincipalName/calendars"
        Get-OGNextPage -uri $URI    
    }
}
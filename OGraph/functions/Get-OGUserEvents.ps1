<#
.SYNOPSIS
Get calendar events for a user

.DESCRIPTION
Get calendar events for a user or provide a filter queary to filter the results.

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-events?view=graph-rest-1.0&tabs=http
.PARAMETER GroupId
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get all calendar events for a group
Get-OGUserEvents -GroupId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Get-OGUserEvents {
    param (
        [Parameter(Mandatory = $True)]$UserPrincipalName,
        [Parameter(Mandatory = $False)]$Filter
    )
    if ($filter) {
        $URI = "/$GraphVersion/users/$userprincipalname/events?`$filter=$filter"
        Get-OGNextPage -URI $URI -Filter
    }
    else {
        $URI = "/$GraphVersion/users/$userprincipalname/events"
        Get-OGNextPage -URI $URI
    }
}
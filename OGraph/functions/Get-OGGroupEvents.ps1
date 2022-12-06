<#
.SYNOPSIS
Get calendar events for a group

.DESCRIPTION
Get calendar events for a group or provide a filter queary to filter the results.
NOTE: Delegated Permission Only
Permissions: https://learn.microsoft.com/en-us/graph/api/group-get-event?view=graph-rest-1.0&tabs=http
.PARAMETER GroupId
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get all calendar events for a group
Get-OGGroupEvents -GroupId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Get-OGGroupEvents {

    param (
        [Parameter(Mandatory = $True)]$GroupId,
        [Parameter(Mandatory = $False)]$Filter
    )
    if ($filter) {

        $URI = "/$GraphVersion/groups/$GroupId/events?`$filter=$filter"
        Get-OGNextPage -URI $URI
    }
    else {
        $URI = "/$GraphVersion/groups/$GroupId/events"
        Get-OGNextPage -URI $URI
    }

}


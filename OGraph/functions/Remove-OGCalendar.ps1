<#
.SYNOPSIS
Delete a specified user calendar

.DESCRIPTION
Delete a specified user calendar

Permissions: https://learn.microsoft.com/en-us/graph/api/calendar-delete?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Parameter description

.PARAMETER SearchDisplayName
Parameter description

.PARAMETER All
Parameter description

.EXAMPLE
Remove-OGCalendar -UserPrincipalName jdoe@contoso.org -Id 79aafc35-e805-491c-bf19-f0b6c28b6be0

.NOTES
General notes
#>
Function Remove-OGCalendar {

    [CmdletBinding(DefaultParameterSetName = 'UPN', SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]$UserPrincipalName,
        [Parameter(Mandatory)]$Id
    )
    $URI = "/$GraphVersion/users/$UserPrincipalName/calendars/$Id"
    $account_params = @{
        Uri    = $URI
        Method = 'DELETE'
    }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName, "remove calendar $($id)")) {
        Invoke-MgGraphRequest @Account_params
    }
}
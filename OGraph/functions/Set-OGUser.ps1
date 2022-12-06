<#
.SYNOPSIS
Set basic fields for a user object or disable an account

.DESCRIPTION
Updated UPN, disable a user, Set firstname, lastname, or displayname

Permissions: https://learn.microsoft.com/en-us/graph/api/user-update?view=graph-rest-1.0&tabs=http

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER NewUserPrincipalName
Parameter description

.PARAMETER accountEnabled
Parameter description

.PARAMETER FirstName
Parameter description

.PARAMETER LastName
Parameter description

.PARAMETER DisplayName
Parameter description

.EXAMPLE
Set-OGUser -UserPrincipalName jdoe@contoso.com -accountEnabled $false

.NOTES
General notes
#>
Function Set-OGUser {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$UserPrincipalName,
        [Parameter(Mandatory = $false)][String]$NewUserPrincipalName,
        [Parameter(Mandatory = $false)][String]$accountEnabled,
        [Parameter(Mandatory = $false)][String]$FirstName,
        [Parameter(Mandatory = $false)][String]$LastName,
        [Parameter(Mandatory = $false)][String]$DisplayName
    )
    $User = Get-OGUser -UserPrincipalName $UserPrincipalName
    $bodyparams = @{}
    if ($NewUserPrincipalName) {
        $bodyparams.add('userPrincipalName', $NewUserPrincipalName)
    }
    if ($accountEnabled) {
        $bodyparams.add('accountEnabled', $accountEnabled)
    }
    if ($FirstName) {
        $bodyparams.add('givenName', $FirstName)
    }
    if ($LastName) {
        $bodyparams.add('surname', $LastName)
    }
    if ($DisplayName) {
        $bodyparams.add('displayName', $DisplayName)
    }
    $Body = [PSCustomObject]@{}
    $body | Add-Member $bodyparams
    $account_params = @{
        Uri         = "/$GraphVersion/users/$($User.Id)"
        body        = $body | ConvertTo-Json -Depth 5
        Method      = 'PATCH'
        ContentType = 'application/json'
    }
    $quietrun = Invoke-GraphRequest @Account_params
}
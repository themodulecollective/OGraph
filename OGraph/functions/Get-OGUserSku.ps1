<#
.SYNOPSIS
Get Azure AD skus for individual user

.DESCRIPTION
Get Azure AD skus for individual user

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-licensedetails?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Parameter description

.EXAMPLE
Get-OGUserSku -UserPrincipalName jdoe@contoso.com

.NOTES
General notes
#>
Function Get-OGUserSku {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName
    )

    $Uri = "$GraphVersion/Users/$($UserPrincipalName)/licenseDetails"
    Get-OGNextPage -uri $Uri
}
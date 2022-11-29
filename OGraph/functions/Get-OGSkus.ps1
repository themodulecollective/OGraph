<#
.SYNOPSIS
Get Azure AD Skus consumed in the tenant

.DESCRIPTION
Long description

Permissions: https://learn.microsoft.com/en-us/graph/api/subscribedsku-list?view=graph-rest-1.0&tabs=http
.EXAMPLE
Get-OGSkus

.NOTES
General notes
#>
Function Get-OGSkus {
    $Uri = "/$GraphVersion/subscribedSkus"
    get-ognextpage -uri $Uri
}
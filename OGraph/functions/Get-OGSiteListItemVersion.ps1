<#
.SYNOPSIS
Get an items version history

.DESCRIPTION
Get an items version history by specifying the site ID, list ID, and item ID

Permissions: https://learn.microsoft.com/en-us/graph/api/listitem-list-versions?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER ListId
Parameter description

.PARAMETER ItemId
Parameter description

.EXAMPLE
Get-OGSiteListItemVersion -SiteId a3299706-eac5-46a1-b5eb-5709bea18e89 -ListId 79aafc35-e805-491c-bf19-f0b6c28b6be0
.NOTES
General notes
#>
Function Get-OGSiteListItemVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId,
        [Parameter(Mandatory)]$ItemId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId/versions"
    $response = Get-OGNextPage -uri $URI
    $response.fields
}


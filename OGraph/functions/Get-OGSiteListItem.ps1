<#
.SYNOPSIS
Get items in a SPO List

.DESCRIPTION
Get items in a SPO List

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
SharePoint Site Identifier

.PARAMETER ListId
SharePoint List Identifier

.PARAMETER ItemId
SharePoint List Item Identifier

.EXAMPLE
Get-OGSiteListItem -SiteId a3299706-eac5-46a1-b5eb-5709bea18e89 -ListId 79aafc35-e805-491c-bf19-f0b6c28b6be0
.NOTES
General notes
#>
Function Get-OGSiteListItem {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId,
        [Parameter(Mandatory = $false)]$ItemId
    )
    if ($ItemId) {
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?expand=fields"
        $response = Get-OGNextPage -uri $URI | Where-Object id -EQ $ItemId
        $response.fields
    }
    else {
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?expand=fields"
        $response = Get-OGNextPage -uri $URI
        $response.fields
    }

}

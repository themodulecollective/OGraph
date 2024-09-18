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

.PARAMETER Column
SharePoint List Column Names

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
        [Parameter(Mandatory = $false)]$ItemId,
        [Parameter(Mandatory = $false)]$Column
    )
    if ($ItemId) {
        if ($Column) {
            $columnString = $column -join ','
            $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$($itemId)?`$expand=fields(`$select=$ColumnString)"
            $response = Get-OGNextPage -uri $URI
            $response.fields
        }
        else {
            $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$itemId"
            $response = Get-OGNextPage -uri $URI
            $response.fields
        }
    }
    else {
        if ($Column) {
            $ColumnString = $Column -join ','
            $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?`$expand=fields(`$select=$ColumnString)"

            write-host $URI
            $response = Get-OGNextPage -uri $URI
            $response.fields
        }
        else {
            $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?expand=fields"
            $response = Get-OGNextPage -uri $URI
            $response.fields
        }

    }

}
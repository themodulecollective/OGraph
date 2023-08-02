<#
.SYNOPSIS
Update an item in a SharePoint Online list

.DESCRIPTION
Update a SharePoint Online list item by providing the SharePoint site ID, the List ID, and the ID of the item to be updated. Next, provide the fields to be updated in a hash table

Permissions: https://learn.microsoft.com/en-us/graph/api/listitem-update?view=graph-rest-1.0&tabs=http

.EXAMPLE
$fields = @{
    field_1 = "Sample String"
}
Update-OGSiteListItem -SiteId 26776db6-ffd1-4e58-a6bf-851d6302733a -ListId 26f11389-ffd1-4e24-a7h1-85af93422733a -ItemId 1234 -Fields $fields

#>
function Update-OGSiteListItem {
    [CmdletBinding(

    )]
    Param(
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId,
        [Parameter(Mandatory)]$ItemId,
        [Parameter(Mandatory)]$Fields
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId/fields"
    $account_params = @{
        URI         = $URI
        body        = $Fields | ConvertTo-Json -Depth 5
        Method      = 'PATCH'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params
}
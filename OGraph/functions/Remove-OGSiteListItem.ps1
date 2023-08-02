<#
.SYNOPSIS
Delete an item in a SharePoint Online list

.DESCRIPTION
Delete a SharePoint Online list item by providing the SharePoint site ID, the List ID, and the ID of the item to be deleted.

Permissions: https://learn.microsoft.com/en-us/graph/api/listitem-delete?view=graph-rest-1.0&tabs=http

.EXAMPLE

Delete-SiteId 26776db6-ffd1-4e58-a6bf-851d6302733a -ListId 26f11389-ffd1-4e24-a7h1-85af93422733a -ItemId 1234 -Fields $fields

#>
function Remove-OGSiteListItem {
    [CmdletBinding(

    )]
    Param(
        #SharePoint Site Identifier
        [Parameter(Mandatory)]
        $SiteId
        ,
        #SharePoint List Identifier
        [Parameter(Mandatory)]
        $ListId
        ,
        #SharePoint List Item Identifier
        [Parameter(Mandatory)]
        $ItemId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId"
    $account_params = @{
        URI         = $URI
        Method      = 'DELETE'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params
}
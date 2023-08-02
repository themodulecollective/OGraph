<#
.SYNOPSIS
 Add new item to a SharePoint list

.DESCRIPTION
Create a SharePoint Online list item by providing the SharePoint site ID, the List ID, and the values of the fields to be added in a hash table.

Permissions: https://learn.microsoft.com/en-us/graph/api/listitem-create?view=graph-rest-1.0&tabs=http
.EXAMPLE
$fields = @{
    field_1 = "Sample String"
}
New-OGSiteListItem -SiteId 26776db6-ffd1-4e58-a6bf-851d6302733a -ListId 26f11389-ffd1-4e24-a7h1-85af93422733a -Fields $fields


.NOTES
General notes
#>
function New-OGSiteListItem {
    [CmdletBinding(

    )]
    Param(
        [Parameter(Mandatory)]
        [String]$SiteId #SharePoint Site Identifier
        ,
        [Parameter(Mandatory)]
        [String]$ListId #SharePoint List Identifier
        ,
        [Parameter(Mandatory)]
        [hashtable]$Fields #Hashtable of item fields and values to include in the new item
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items"
    $body = @{fields = $Fields }
    $account_params = @{
        URI         = $URI
        body        = $body | ConvertTo-Json -Depth 5
        Method      = 'POST'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params
}
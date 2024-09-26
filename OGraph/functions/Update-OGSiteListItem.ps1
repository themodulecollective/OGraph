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
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        #SharePoint Site Identifier
        [Parameter(Mandatory)]
        [String]$SiteId
        ,
        #SharePoint List Identifier
        [Parameter(Mandatory)]
        [String]$ListId
        ,
        #SharePoint List Item Identifier
        [Parameter(Mandatory)]
        [string]$ItemId
        ,
        #Hashtable of item fields and Values to update in the item
        [Parameter(Mandatory)]
        [hashtable]$Fields
        ,
        #Removes fields with empty strings from the $Fields hash table
        [Parameter()]
        [switch]$RemoveNullField
    )
    if ($RemoveNullField) {
        $Values = @{}
        $fields.Keys.ForEach({
                if (-not [string]::IsNullOrEmpty($fields[$_])) {
                    $Values[$_] = $fields[$_]
                }
            })
    }
    else {
        $Values = $fields
    }
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId/fields"
    $account_params = @{
        URI         = $URI
        body        = $Values | ConvertTo-Json -Depth 5
        Method      = 'PATCH'
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($ItemID,'PATCH'))
    {
        Invoke-MgGraphRequest @Account_params
    }
}
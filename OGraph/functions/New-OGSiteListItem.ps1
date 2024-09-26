<#
.SYNOPSIS
 Add new item to a SharePoint list
.DESCRIPTION
Create a SharePoint Online list item by providing the SharePoint site ID, the List ID, and the Values of the fields to be added in a hash table.
Permissions: https://learn.microsoft.com/en-us/graph/api/listitem-create?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
SharePoint Site Identifier
.PARAMETER ListId
SharePoint List Identifier
.PARAMETER Fields
Hashtable of item fields and Values to include in the new SharePoint List Item
.PARAMETER RemoveNullField
Removes fields with empty strings from the $Fields hash table
.EXAMPLE
$fields = @{
    field_1 = "Sample String"
}
New-OGSiteListItem -SiteId 26776db6-ffd1-4e58-a6bf-851d6302733a -ListId 26f11389-ffd1-4e24-a7h1-85af93422733a -Fields $fields


.NOTES
General notes
#>
function New-OGSiteListItem {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]
        [String]$SiteId
        ,
        [Parameter(Mandatory)]
        [String]$ListId
        ,
        [Parameter(Mandatory)]
        [hashtable]$Fields
        ,
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
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items"
    $body = @{fields = $Values }
    $account_params = @{
        URI         = $URI
        body        = $body | ConvertTo-Json -Depth 5
        Method      = 'POST'
        ContentType = 'application/json'
    }
    if ($PSCmdlet.ShouldProcess($ItemID, 'POST')) {
        Invoke-MgGraphRequest @Account_params
    }
}
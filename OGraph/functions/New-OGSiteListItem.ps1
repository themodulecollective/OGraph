<#
.SYNOPSIS
 Add new item to a SharePoint list

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-OGSiteListItem {
    [CmdletBinding(

    )]
    Param(
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId,
        [Parameter(Mandatory)]$Fields
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items"
    $body = @{fields = $Fields }
    $account_params = @{
        URI         = $URI
        body        = $body | ConvertTo-Json -Depth 5
        Method      = 'POST'
        ContentType = 'application/json'
    }
    $account_params.body
    Invoke-MgGraphRequest @Account_params
}
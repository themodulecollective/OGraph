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
        [Parameter(Mandatory)][Switch]$ListId,
        [Parameter(Mandatory)][Switch]$Fields
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items"
    $account_params = @{
        URI         = $URI
        Fields      = $Fields
        Method      = 'POST'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params
}
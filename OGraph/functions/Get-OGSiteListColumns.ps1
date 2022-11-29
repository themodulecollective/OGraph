<#
.SYNOPSIS
Get columns contained in an SPO site list

.DESCRIPTION
Get columns contained in an SPO site list

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER ListId
Parameter description

.EXAMPLE
Get-OGSiteListColumns -SiteId b767d342-3712-492a-94dc-504304cb8412 -ListId c1e7d5b3-ed9e-409e-a956-9d77df7c1ec3

.NOTES
General notes
#>
Function Get-OGSiteListColumns {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/Columns"
    Get-OGNextPage -uri $URI

}


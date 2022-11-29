<#
.SYNOPSIS
Get the lists in a Sharepoint Online Site

.DESCRIPTION
Get the lists in a Sharepoint Online Site

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.EXAMPLE
Get-OGSiteList -SiteId b767d342-3712-492a-94dc-504304cb8412

.NOTES
General notes
#>
Function Get-OGSiteList {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists"
    Get-OGNextPage -uri $URI

}


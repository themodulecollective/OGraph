<#
.SYNOPSIS
List subsites for a site

.DESCRIPTION
List subsites for a site

Permissions: https://learn.microsoft.com/en-us/graph/api/site-list-subsites?view=graph-rest-1.0&tabs=http

.PARAMETER SiteId
SharePoint Site Identifier

.EXAMPLE
Get-OGSiteSubsite -SiteId f232e745-0801-4705-beb6-4d9880fc92b4

.NOTES
General notes
#>
Function Get-OGSiteSubsite {

    [CmdletBinding(DefaultParameterSetName = 'SID')]
    Param(
        [Parameter(Mandatory)]
        $SiteId
    )
    $URI = "/$GraphVersion/sites/$SiteId/sites"
    Get-OGNextPage -uri $URI

}
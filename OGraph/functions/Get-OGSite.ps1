<#
.SYNOPSIS
Get specified or all Sharepoint Online Sites in a tenant

.DESCRIPTION
Get specified or all Sharepoint Online Sites in a tenant

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http

.PARAMETER SiteId
SharePoint Site Identifier

.PARAMETER SiteURL
SharePoint Site URL

.PARAMETER All
Get all SharePoint Sites for the connected tenant

.PARAMETER IncludePersonalSites
Include OneDrive for Business Sites in the results

.EXAMPLE
Get-OGSite -SiteId f232e745-0801-4705-beb6-4d9880fc92b4

.NOTES
General notes
#>
Function Get-OGSite {

    [CmdletBinding(DefaultParameterSetName = 'SID')]
    Param(
        [Parameter(Mandatory,
            ParameterSetName = 'SID')]$SiteId,
        [Parameter(Mandatory,
            ParameterSetName = 'URL')]$SiteURL,
        [Parameter(Mandatory,
            ParameterSetName = 'All')][Switch]$All,
        [Parameter(Mandatory = $False,
            ParameterSetName = 'All')][Switch]$IncludePersonalSites
    )
    switch ($PSCmdlet.ParameterSetName) {
        'SID' {
            $account_params = @{
                Uri         = "/$GraphVersion/sites/$SiteId"
                Method      = 'GET'
                OutputType  = 'PSObject'
                ContentType = 'application/json'
            }
            Invoke-MgGraphRequest @Account_params
        }
        'URL' {
        $SiteURI = [uri]::new($SiteURL)

            $account_params = @{
                Uri         = "/$GraphVersion/sites/$($SiteURI.Host):/$($SiteURI.LocalPath)"
                Method      = 'GET'
                OutputType  = 'PSObject'
                ContentType = 'application/json'
            }
            Invoke-MgGraphRequest @Account_params
        }
        'All' {
            $URI = "/$GraphVersion/sites/?$search=*"
            $allResults = Get-OGNextPage -uri $URI
            switch ($IncludePersonalSites) {
                True { $allResults }
                False { $allResults | Where-Object WebUrl -NotLike '*/personal/*' }
            }
        }
    }
}
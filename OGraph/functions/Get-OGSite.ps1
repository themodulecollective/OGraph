<#
.SYNOPSIS
Get specified or all Sharepoint Online Sites in a tenant

.DESCRIPTION
Get specified or all Sharepoint Online Sites in a tenant

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER All
Parameter description

.PARAMETER IncludePersonalSites
Parameter description

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
            Invoke-GraphRequest @Account_params
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
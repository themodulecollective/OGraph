<#
.SYNOPSIS
REcursive Helper function for simplifying graph api requests including next page functionality

.DESCRIPTION
Recursive Helper function for simplifying graph api requests including next page functionality.

.PARAMETER URI
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get-OGNextpage -URI "/v1.0/users"

.NOTES
General notes
#>
Function Get-OGNextPage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$URI,
        [Parameter(Mandatory = $False)][Switch]$Filter
    )
    $account_params = @{
        URI         = $URI
        Method      = 'GET'
        OutputType  = 'PSObject'
        ContentType = 'application/json'
    }
    switch ($filter) {
        $true {
            $account_params.add('Headers', @{})
            $account_params.Headers.add('ConsistencyLevel', 'eventual')
        }
    }
    $Result = Invoke-MgGraphRequest @Account_params
    switch ($null -ne $Result.value) {
        $true {
            $Result.value
        }
        $False {
            $Result | Select-Object -ExcludeProperty '@odata.*'
        }
    }
    if ($result.'@odata.nextlink') {
        Get-OGNextPage -Uri $result.'@odata.nextlink'
    }
}
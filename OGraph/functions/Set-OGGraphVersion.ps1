<#
.SYNOPSIS
Switch between graph api versions beta and v1.0

.DESCRIPTION
Switch between graph api versions beta and v1.0

.PARAMETER Beta
Parameter description

.PARAMETER v1
Parameter description

.EXAMPLE
Set-OGVersion -beta

.NOTES
General notes
#>
Function Set-OGGraphVersion {
    
    [CmdletBinding(DefaultParameterSetName = 'v1')]
    param (
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Beta')][switch]$Beta,
        [Parameter(Mandatory = $false,
            ParameterSetName = 'v1')][switch]$v1
    )
    switch ($PSCmdlet.ParameterSetName) {
        'Beta' {
            $Script:GraphVersion = 'beta'
        }
        'v1' {
            $Script:GraphVersion = 'v1.0'
        }
    }
}


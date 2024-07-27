<#
.SYNOPSIS
Get user OneDrive Meta information

.DESCRIPTION
Get user OneDrive Meta information

Permissions: https://learn.microsoft.com/en-us/graph/api/drive-get?view=graph-rest-1.0&tabs=http
.EXAMPLE
Get-OGUserDrive -userprincipalname test.user@domain.com
.NOTES
General notes
#>
Function Get-OGUserDrive {

    [CmdletBinding()]
    param (
        #Specify the UserPrincipalName OR ID for the user
        [Parameter(Mandatory)]
        $UserPrincipalName
        ,
        # Specify whether to pass through the UserPrincipalName to the output object at an attribute of the output
        [parameter()]
        [alias('PassthruUPN')]
        [switch]$PassthruUserPrincipalName
    )
    $URI = "/$GraphVersion/users/$userprincipalname/drive"

    try {$rawDrive = Get-OGNextPage -uri $URI -ErrorAction Stop}
    catch {
        Write-Warning -Message $_.tostring()
    }


    if ($PassthruUserPrincipalName) {
        $rawDrive = $rawDrive | Select-Object -Property @{n='UserPrincipalName';e={$UserPrincipalName}},*
    }

    $rawDrive
}
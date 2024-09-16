<#
.SYNOPSIS
Retrieve the properties and relationships of a users Drive resource

.DESCRIPTION
Retrieve the properties and relationships of a users Drive resource

A Drive is the top-level container for a file system, such as OneDrive or SharePoint document libraries.

.PARAMETER UserPrincipalName
Provide the UserPrincipalName or User Id of the user

.EXAMPLE
Get-OGDriveUser -UserPrincipalName 'test@domain.com'

.NOTES
General notes
#>
Function Get-OGDriveUser {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$UserPrincipalName
    )

    $account_params = @{
        Uri         = "/$GraphVersion/users/$UserPrincipalName/drive"
        Method      = 'GET'
        OutputType  = 'PSObject'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params

}
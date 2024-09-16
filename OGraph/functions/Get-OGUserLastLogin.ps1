<#
.SYNOPSIS
Get users from Entra ID with there signInActivity

.DESCRIPTION
Get users from Entra ID with there signInActivity

.PARAMETER UserPrincipalName
Get users by the UserPrincipalName

.PARAMETER UserID
Get users by the entra user id

.PARAMETER All
Get last login for all users

NOTE: The signInActivity call made by Graph only accepts Entra Id. The parameter will be less performant than UserId because users the UPN to get the user Id.

.PARAMETER Property
Select additional properties of a user

.EXAMPLE
Get-OGUserLastLogin -UserId d7e0Qb89-6ef6-4a6b-433f-193558b630ff

.NOTES
The signInActivity property only works with Graph version Beta. The function automatically changes the graph version to beta but does not change it globally.
#>
Function Get-OGUserLastLogin {
    [CmdletBinding(DefaultParameterSetName = 'UserId')]
    param (
        [Parameter(ParameterSetName = 'UserID' )]
        [string]$UserID
        ,
        [Parameter(ParameterSetName = 'UPN')]
        [string]$UserPrincipalName
        ,
        [Parameter(ParameterSetName = 'All')]
        [switch]$All
        ,
        [Parameter()]
        [string[]]$Property
    )

    $includeAttributes = 'signInActivity', 'businessPhones', 'displayName', 'givenName', 'id', 'jobTitle', 'mail', 'mobilePhone', 'officeLocation', 'preferredLanguage', 'surname', 'UserID'
    $IncludeAttributeString = $($($includeAttributes; $Property) | Sort-Object -unique) -join ','
    $GraphVersion = 'Beta'
    switch ($PSCmdlet.ParameterSetName) {
        'UserID' {
            $URI = "/$GraphVersion/users/$($UserID)?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -URI $URI -Filter
        }
        'UPN' {
            $UserID = $(Get-OGUser -UserPrincipalName $UserPrincipalName -ErrorAction Stop).id
            switch ([string]::IsNullOrWhiteSpace($UserID))
            {
                $false
                {
                    $URI = "/$GraphVersion/users/$($UserID)?`$select=$($IncludeAttributeString)"
                    Get-OGNextPage -URI $URI -Filter
                }
            }

        }
        'All' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -URI $URI
        }
    }
}
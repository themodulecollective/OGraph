<#
.SYNOPSIS
Get users from Entra ID with there signInActivity

.DESCRIPTION
Get users from Entra ID with there signInActivity

.PARAMETER UserID
Get users by the entra user id

.PARAMETER All
Get users by the Entra userprincipalname

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
        [Parameter(ParameterSetName = 'UserID', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$UserID
        ,
        [Parameter(ParameterSetName = 'UPN', ValueFromPipeline, ValueFromPipelineByPropertyName)]
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
            $UserID = $(Get-OGUser -UserPrincipalName $UserPrincipalName).id
            $URI = "/$GraphVersion/users/$($UserID)?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -URI $URI -Filter
        }
        'All' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -URI $URI
        }
    }
}
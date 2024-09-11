<#
.SYNOPSIS
Get users from Azure AD

.DESCRIPTION
Get users from Azure AD

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Get Users by userprincipalname

.PARAMETER SearchDisplayName
Search for users by displayname

.PARAMETER All
Get all users in tenant

.PARAMETER Property
Select additional properties of a user

.EXAMPLE
Get-OGUser -UserPrincipalName test@testaccount.onmicrosoft.com

.NOTES
General notes
#>
Function Get-OGUser {

    [CmdletBinding(DefaultParameterSetName = 'UPN')]
    param (
        [Parameter(ParameterSetName = 'UPN')]$UserPrincipalName,
        [Parameter(ParameterSetName = 'Search')]$SearchDisplayName,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All,
        [Parameter()]
        [string[]]$Property
    )
    $includeAttributes = 'businessPhones', 'displayName', 'givenName', 'id', 'jobTitle', 'mail', 'mobilePhone', 'officeLocation', 'preferredLanguage', 'surname', 'userPrincipalName'
    $IncludeAttributeString = $($($includeAttributes; $Property) | Sort-Object -unique) -join ','
    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $URI = "/$GraphVersion/users/$($userprincipalname)?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
        'Search' {
            $IncludeAttributeString = $includeAttributes -split ','
            $URI = "/$GraphVersion/users?`$search=`"displayName:$SearchDisplayName`""
            Get-OGNextPage -uri $URI -filter | select-object $IncludeAttributeString
        }
        'All' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
    }
}
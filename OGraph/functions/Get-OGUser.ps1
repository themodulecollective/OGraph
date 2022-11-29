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
    $IncludeAttributeString = $($includeAttributes; $Property) -join ','
    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $URI = "/$GraphVersion/users/$($userprincipalname)?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
        'Search' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)`$search=`"displayName:$SearchDisplayName`""
            Get-OGNextPage -uri $URI -filter
        }
        'All' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
    }
}
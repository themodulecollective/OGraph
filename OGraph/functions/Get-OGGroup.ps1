<#
.SYNOPSIS
Get group from Azure AD
.DESCRIPTION
Get group using an Object ID, by searching for a displayname, or getting all groups.

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER SearchDisplayName
Parameter description

.PARAMETER All
Parameter description

.PARAMETER Property
Parameter description

.EXAMPLE
Get a group by Object ID
Get-OGGroup -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroup {
    [CmdletBinding(DefaultParameterSetName = 'OID')]
    param (
        [Parameter(ParameterSetName = 'OID')]
        $GroupId,
        [Parameter(ParameterSetName = 'Search')]$SearchDisplayName,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All,
        [Parameter()]
        [string[]]$Property
    )
    $includeAttributes = 'classification', 'createdByAppId', 'createdDateTime', 'deletedDateTime', 'description', 'displayName', 'expirationDateTime', 'groupTypes', 'id', 'infoCatalogs', 'isAssignableToRole', 'isManagementRestricted', 'mail', 'mailEnabled', 'mailNickname', 'membershipRule', 'membershipRuleProcessingState', 'onPremisesDomainName', 'onPremisesLastSyncDateTime', 'onPremisesNetBiosName', 'onPremisesProvisioningErrors', 'onPremisesSamAccountName', 'onPremisesSecurityIdentifier', 'onPremisesSyncEnabled', 'organizationId', 'preferredDataLocation', 'preferredLanguage', 'proxyAddresses', 'renewedDateTime', 'resourceBehaviorOptions', 'resourceProvisioningOptions', 'securityEnabled', 'securityIdentifier', 'theme', 'visibility', 'writebackConfiguration'
    $IncludeAttributeString = $($includeAttributes; $property) -join ','
    switch ($PSCmdlet.ParameterSetName) {
        'OID' {
            $URI = "/$GraphVersion/groups/$($GroupId)?`$select=$($IncludeAttributeString)"
            get-ognextpage -uri $uri
        }
        'Search' {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)`$search=`"displayName:$SearchDisplayName`""
            Get-OGNextPage -uri $URI -Filter
        }
        'All' {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
    }
}
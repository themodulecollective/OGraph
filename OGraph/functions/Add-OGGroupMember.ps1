<#
.SYNOPSIS
Add Group Member

.DESCRIPTION
Add a group member using its object id or user principal name. If using the later, a lookup is performed with get-oguser to get the Object ID for the user.

Permissions: https://learn.microsoft.com/en-us/graph/api/group-post-members?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER MemberId
Parameter description

.EXAMPLE
Add-OGGroupMember -GroupObjectId 3175b598-0fa0-4002-aebf-bfbf759c94a7 -UserObjectId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Add-OGGroupMember {
    [CmdletBinding(DefaultParameterSetName = 'MID')]

    param (
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $GroupId,
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $UserPrincipalName,
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        $MemberId
    )

    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $MemberId = Get-OGUser -UserPrincipalName $UserPrincipalName
            $MemberId = $MemberId.Id
        }
    }
    $URI = "/$GraphVersion/groups/$GroupID/members/`$ref"
    $Body = [PSCustomObject]@{
        '@odata.id' = "https://graph.microsoft.com/$GraphVersion/directoryObjects/$MemberId"
    }
    $account_params = @{
        Uri    = $URI
        Body   = $Body | ConvertTo-Json
        Method = 'POST'
    }
    Invoke-GraphRequest @Account_params
}
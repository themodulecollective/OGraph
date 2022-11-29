<#
.SYNOPSIS
Remove member from Azure AD group membership

.DESCRIPTION
Remove member from Azure AD group membership

Permissions: https://learn.microsoft.com/en-us/graph/api/group-delete-members?view=graph-rest-1.0&tabs=http
.PARAMETER ObjectId
Id of the groupt to remove the user from

.PARAMETER MemberId
Id of the user

.EXAMPLE
Remove-OGGroupMember -ObjectId a3299706-eac5-46a1-b5eb-5709bea18e89 -MemberId b767d342-3712-492a-94dc-504304cb8412

.NOTES
General notes
#>
Function Remove-OGGroupMember {

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
    $URI = "/$GraphVersion/groups/$GroupId/members/$MemberId/`$ref"
    $account_params = @{
        Uri    = $URI
        Method = 'DELETE'
    }
    Invoke-GraphRequest @Account_params
}
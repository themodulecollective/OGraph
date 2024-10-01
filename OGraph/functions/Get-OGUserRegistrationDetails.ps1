<#
.SYNOPSIS
Get the registration details of a user or all users

.DESCRIPTION
Get the registration details of a user or all users.

NOTE: Using UserId on a large list of users will be slightly more performant. A lookup is being performed when using the UserPrincipalName to get the Id as the endpoint will not accept UserPrincipalName.
.PARAMETER UserPrincipalName
Get user registration details by the UserPrincipalName

.PARAMETER UserId
Get user registration details by the UserId

NOTE: Using UserId users will be slightly more performant. A lookup is being performed when using the UserPrincipalName to get the Id as the endpoint will not accept UserPrincipalName.
.PARAMETER All
Get user registration details for all users

.EXAMPLE
Get-OGUserRegistrationDetails -UserId d7e0Qb89-6ef6-4a6b-433f-193558b630ff

.NOTES
General notes
#>
Function Get-OGUserRegistrationDetails {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'UPN', Mandatory)]
        $UserPrincipalName,

        [Parameter(ParameterSetName = 'UserId', Mandatory)]
        $UserId,

        [Parameter(ParameterSetName = 'All')]
        [Switch]$All
    )


    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $UserID = $(Get-OGUser -UserPrincipalName $UserPrincipalName -ErrorAction Stop).id
            switch ([string]::IsNullOrWhiteSpace($UserID)) {
                $false {
                    $URI = "/$GraphVersion/reports/authenticationMethods/userRegistrationDetails/$($UserID)"
                    Get-OGNextPage -Uri $URI
                }
            }

        }
        'UserId' {
            $URI = "/$GraphVersion/reports/authenticationMethods/userRegistrationDetails/$($UserID)"
            Get-OGNextPage -Uri $URI
        }
        'All' {
            $URI = "/$GraphVersion/reports/authenticationMethods/userRegistrationDetails/"
            Get-OGNextPage -Uri $URI
        }
    }
}
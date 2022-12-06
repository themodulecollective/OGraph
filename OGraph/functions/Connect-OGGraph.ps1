<#
.SYNOPSIS
Get API Token from Azure AD app using Access Secret or Certificate Thumprint, then authenticate to graph with the token. Or authenticate using user credentials.

.DESCRIPTION
This function allows easy Authentication to Azure AD application authentication tokens or User Credentials. To get a Azure AD application token, provide the tenant ID, Application ID, and either an access secret or certificate thumbprint. The token with automatically authenticate the session after a valid token is acquired or online credentials are entered. If you have an existing token, paste it into accesstoken.

.PARAMETER ApplicationID
Parameter description

.PARAMETER TenantId
Parameter description

.PARAMETER AccessSecret
Parameter description

.PARAMETER CertificateThumbprint
Parameter description

.PARAMETER Online
Parameter description

.PARAMETER AccessToken
Parameter description

.EXAMPLE
Authenticate to graph with application access secret:
Connect-OGGraph -ApplicationID f3857fc2-d4a5-1427-8f4c-2bdcd0cd9a2d -TenantID 27f1409e-4f28-4115-8ef5-71058ab01821 -AccessSecret Rb4324~JBiAJclWeG1W239CPgKHlChi9l0423jjdg~

.NOTES
General notes
#>
Function Connect-OGGraph {
    [CmdletBinding(DefaultParameterSetName = 'Online')]
    param (
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $ApplicationID,
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $TenantId,
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        $AccessSecret,
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $CertificateThumbprint,
        [Parameter(Mandatory,
            Parametersetname = 'Online')]
        [Switch]$Online,
        [Parameter(Mandatory,
            Parametersetname = 'Token')]
        $AccessToken

    )
    switch ($PSCmdlet.ParameterSetName) {
        'Secret' {
            $Body = @{
                Grant_Type    = 'client_credentials'
                Scope         = 'https://graph.microsoft.com/.default'
                client_Id     = $ApplicationID
                Client_Secret = $AccessSecret
            }
            $ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $Body
            $script:GraphAPIKey = $ConnectGraph.access_token
            Connect-MgGraph -AccessToken $GraphAPIKey
        }
        'Cert' {
            $splat = @{
                ClientID              = $ApplicationID
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            Connect-MGGraph @splat
        }
        'Online' {
            Connect-MgGraph
        }
        'Token' {
            Connect-MgGraph -AccessToken $AccessToken
        }
    }
}
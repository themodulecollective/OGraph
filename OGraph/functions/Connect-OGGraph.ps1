<#
.SYNOPSIS
Get API Token from Azure AD app using Access Secret or Certificate Thumprint, then authenticate to graph with the token. Or authenticate using user credentials.

.DESCRIPTION
This function allows easy Authentication to Azure AD application authentication tokens or User Credentials. To get a Azure AD application token, provide the tenant ID, Application ID, and either an access secret or certificate thumbprint. The token with automatically authenticate the session after a valid token is acquired or online credentials are entered. If you have an existing token, paste it into accesstoken.

.PARAMETER ApplicationID
Identifier for the Application Registration to use for connection to the Microsoft Tenant

.PARAMETER TenantId
Identifier for the Microsoft Tenant

.PARAMETER ClientSecret
Client Secret for the Application Registration to be used for client authentication for connection to the Microsoft Tenant

.PARAMETER CertificateThumbprint
Certificat thumbprint of the certificate to be used for client authentiaction for connection to the Microsoft Tenant

.PARAMETER UseDeviceAuthentication
Use device code flow

.PARAMETER Scope
Specify the Microsoft Graph scope(s) to include in the connection context.  User must have appropriate permissions and/or be able to consent to the permissions.

.PARAMETER AccessToken
Specify the pre-obtained access code to use for the connection to the Microsoft Tenant

.EXAMPLE
Authenticate to graph with application access secret:
Connect-OGGraph -ApplicationID f3857fc2-d4a5-1427-8f4c-2bdcd0cd9a2d -TenantID 27f1409e-4f28-4115-8ef5-71058ab01821 -AccessSecret Rb4324~JBiAJclWeG1W239CPgKHlChi9l0423jjdg~

.NOTES
General notes
#>
Function Connect-OGGraph
{
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    param (

        [Parameter(Mandatory,Parametersetname = 'Secret')]
        [Parameter(Mandatory,Parametersetname = 'Cert')]
        $ApplicationID
        ,
        [Parameter(Mandatory,Parametersetname = 'Secret')]
        [Parameter(Mandatory,Parametersetname = 'Cert')]
        $TenantId
        ,
        [Parameter(Mandatory,Parametersetname = 'Secret')]
        $ClientSecret
        ,
        [Parameter(Mandatory,Parametersetname = 'Cert')]
        $CertificateThumbprint
        ,
        [Parameter(Parametersetname = 'Interactive')]
        [Parameter(Parametersetname = 'DeviceAuth')]
        [string[]]$Scope
        ,
        [Parameter(Mandatory,Parametersetname = 'Token')]
        $AccessToken
        ,
        [Parameter(Mandatory,Parametersetname = 'DeviceAuth')]
        [switch]$UseDeviceAuthentication
    )
    switch ($PSCmdlet.ParameterSetName)
    {
        'Secret'
        {
            $Body = @{
                Grant_Type    = 'client_credentials'
                Scope         = 'https://graph.microsoft.com/.default'
                client_Id     = $ApplicationID
                Client_Secret = $ClientSecret
            }
            $ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $Body
            $script:GraphAPIKey = $ConnectGraph.access_token
            Connect-MgGraph -AccessToken $GraphAPIKey
        }
        'Cert'
        {
            $splat = @{
                ClientID              = $ApplicationID
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            Connect-MgGraph @splat
        }
        'Interactive'
        {
            switch ($scope.count -ge 1)
            {
                $true
                {
                    Connect-MgGraph -UseDeviceAuthentication -Scopes $Scope
                }
                $false
                {
                    Connect-MgGraph
                }
            }
        }
        'DeviceAuth'
        {
            switch ($scope.count -ge 1)
            {
                $true
                {
                    Connect-MgGraph -UseDeviceAuthentication -Scopes $Scope
                }
                $false
                {
                    Connect-MgGraph -UseDeviceAuthentication
                }
            }

        }
        'Token'
        {
            Connect-MgGraph -AccessToken $AccessToken
        }
    }
}
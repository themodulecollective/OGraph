
<#
.SYNOPSIS
Get an Access Token for MS Graph with either an app secret or certificate thumbprint

.DESCRIPTION
Get an Access Token for MS Graph with either an app secret or certificate thumbprint

.PARAMETER ApplicationID
The ID of your Azure App Registration

.PARAMETER TenantId
The tenant ID of the tenant where the application is registered

.PARAMETER ClientSecret
The client secret generated in the app

.PARAMETER CertificateThumbprint
The thumbprint of the certificate added to your app

.EXAMPLE
Get-OGAccessToken -ApplicationID 9664j1df-i1cb-489c-9f51-ff9d33d2k585 -TenantId 34fc6o5f-c773-4caa-ae20-b226c36b8e65 -ClientSecret $secret 'Bf08Q~8UOzeqTEpzkWgbFCOkGyuyacgOgjqzCarw'

.NOTES
Token flows detailed here: https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow
#>
Function Get-OGAccessToken {
    [CmdletBinding(DefaultParameterSetName = 'Secret')]
    param (

        [Parameter(Mandatory, Parametersetname = 'Secret')]
        [Parameter(Mandatory, Parametersetname = 'Cert')]
        $ApplicationID
        ,
        [Parameter(Mandatory, Parametersetname = 'Secret')]
        [Parameter(Mandatory, Parametersetname = 'Cert')]
        $TenantId
        ,
        [Parameter(Mandatory, Parametersetname = 'Secret')]
        $ClientSecret
        ,
        [Parameter(Mandatory, Parametersetname = 'Cert')]
        $CertificateThumbprint

    )

    switch ($PSCmdlet.ParameterSetName) {
        Secret {
            $Body = @{
                Grant_Type    = 'client_credentials'
                Scope         = 'https://graph.microsoft.com/.default'
                client_Id     = $ApplicationID
                Client_Secret = $ClientSecret
            }
        }
        Cert {
            $Body = @{
                Grant_Type            = 'client_credentials'
                Scope                 = 'https://graph.microsoft.com/.default'
                client_Id             = $ApplicationID
                client_assertion_type = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer'
                client_assertion      = $CertificateThumbprint
            }
        }
    }

    $Body = @{
        Grant_Type    = 'client_credentials'
        Scope         = 'https://graph.microsoft.com/.default'
        client_Id     = $ApplicationID
        Client_Secret = $Secret
    }
    $ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $Body
    $ConnectGraph.access_token

}
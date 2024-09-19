function Get-OGSiteListItemFailureField {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        #SharePoint Site Identifier
        [Parameter(Mandatory)]
        [String]$SiteId
        ,
        #SharePoint List Identifier
        [Parameter(Mandatory)]
        [String]$ListId
        ,
        #SharePoint List Item Identifier
        [Parameter(Mandatory)]
        [string]$ItemId
        ,
        #Hashtable of item fields and values to update in the item
        [Parameter(Mandatory)]
        [hashtable]$Fields


    )
    foreach ($entry in $fields.GetEnumerator()) {
        $checkHash = @{}
        $checkHash[$entry.Key] = $entry.Value
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId/fields"
        $account_params = @{
            URI         = $URI
            body        = $checkHash | ConvertTo-Json -Depth 5
            Method      = 'PATCH'
            ContentType = 'application/json'
        }
        Write-host $entry.Key = $entry.Value
        if ($PSCmdlet.ShouldProcess($ItemID, 'PATCH')) {
            try {
                Invoke-MgGraphRequest @Account_params
            }
            catch {
                write-host "$($entry.key) = $($entry.value)"
                return
            }

        }
    }
}
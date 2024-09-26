<#
.SYNOPSIS
Patches each field in a SPO list item and returns any that fail

.DESCRIPTION
Patches each field in a SPO list item and returns any that fail

.EXAMPLE
$fields = @{
    field_1 = "Sample String"
    field_2 = "Sample String2"
}
Get-OGSiteListItemFailureField -SiteId 26776db6-ffd1-4e58-a6bf-851d6302733a -ListId 26f11389-ffd1-4e24-a7h1-85af93422733a -ItemId 1234 -Fields $fields

.NOTES
General notes
#>
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
        $Check = @{}
        $Check[$entry.Key] = $entry.Value
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items/$ItemId/fields"
        $account_params = @{
            URI         = $URI
            body        = $Check | ConvertTo-Json -Depth 5
            Method      = 'PATCH'
            ContentType = 'application/json'
        }
        # Write-host $entry.Key = $entry.Value
        if ($PSCmdlet.ShouldProcess($ItemID, 'PATCH')) {
            try {
                $null = Invoke-MgGraphRequest @Account_params
            }
            catch {
                Write-Information -MessageData $('Failed: ' +  $entry.Key + ' = ' + $entry.Value) -InformationAction Continue
                $_
            }

        }
    }
}
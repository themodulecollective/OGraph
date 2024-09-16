<#
.SYNOPSIS
Remove a file from a user's OneDrive using the DriveId and the files Drive unique id

.DESCRIPTION
Remove a file from a user's OneDrive using the DriveId and the files Drive unique id with the option to permanently delete the file.

.PARAMETER DriveId
The Drive id which can be found with Get-OGDriveUser

.PARAMETER ItemId
The unique id of the file

.PARAMETER PermanentDelete
Will bypass the recyle bin and permanently remove the file

.EXAMPLE
Remove-OGDriveItemById -DriveId "b!bICvC12eVkG3A6E0TLfXhEHaOgbTPzRPjOXJAb7nX89Stj2yZVjpT7n-msgD_iiC" -ItemId 76a70926-551a-4dlb-b5c9-b6044a6efeEc

.NOTES
General notes
#>
function Remove-OGDriveItemById {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        $DriveId
        ,
        [Parameter(Mandatory)]
        $ItemId,
        [Parameter()][switch]
        $PermanentDelete
    )
    switch ($PermanentDelete) {
        false {
            $URI = "/$GraphVersion/drives/$DriveId/items/$ItemId"
            $account_params = @{
                URI         = $URI
                Method      = 'DELETE'
                ContentType = 'application/json'
            }
            Invoke-MgGraphRequest @Account_params
        }
        true {
            $URI = "/$GraphVersion/drives/$DriveId/items/$ItemId/permanentDelete"
            $account_params = @{
                URI         = $URI
                Method      = 'POST'
                ContentType = 'application/json'
            }
            Invoke-MgGraphRequest @Account_params
        }
    }
}

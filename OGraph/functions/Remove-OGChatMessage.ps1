<#
.SYNOPSIS
Delete Team's chat using the Chat's ID

.DESCRIPTION
Delete Team's chat using the Chat's ID

.PARAMETER ChatId
The Chat Id

.EXAMPLE
Remove-OGChatMessages -ChatId "19:1f8823b7-4ef3-4e6e-aca5-2553f676bd73_85c55e4c-6356-4cf7-b564-928b1034c4ac@unq.gbl.spaces"

.NOTES
General notes
#>
function Remove-OGChatMessages {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        $ChatId
    )

    $URI = "/$GraphVersion/chats/$chatId"
    $account_params = @{
        URI         = $URI
        Method      = 'DELETE'
        ContentType = 'application/json'
    }
    Invoke-MgGraphRequest @Account_params

}
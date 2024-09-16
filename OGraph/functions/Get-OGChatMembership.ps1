<#
.SYNOPSIS
Get the members of a chat

.DESCRIPTION
Get the members of a chat use the chat id

.PARAMETER ChatId
The id of the chat

.EXAMPLE
Get-OGChatMembership -ChatId "19:18ef635hj65d0454f99b10cb941541ba2@thread.v2"

.NOTES
General notes
#>
Function Get-OGChatMembership {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$ChatId
    )
    $URI = "/$GraphVersion/chats/$ChatId/members"
    Get-OGNextPage -uri $URI

}
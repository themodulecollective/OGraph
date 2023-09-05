<#
.SYNOPSIS
Get the current version of the Graph API that OGraph is using

.DESCRIPTION
Get the current version of the Graph API that OGraph is using

.EXAMPLE
Get-OGGraphVersion
#>
Function Get-OGGraphVersion
{
    $Script:GraphVersion
}

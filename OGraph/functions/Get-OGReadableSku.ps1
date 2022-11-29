<#
.SYNOPSIS
Provide human readable description to M365 Service Plans by parsing the Microsoft Docs here:
https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/active-directory/enterprise-users/licensing-service-plan-reference.md

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
Many thanks to junecastillote for his work found here: https://github.com/junecastillote/Microsoft-365-License-Friendly-Names

MIT License

Copyright (c) 2020 June Castillote

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>
function Get-OGReadableSku {
    [CmdletBinding()]
    param ()
    $URL = 'https://raw.githubusercontent.com/MicrosoftDocs/azure-docs/master/articles/active-directory/enterprise-users/licensing-service-plan-reference.md'
    [System.Collections.ArrayList]$raw_Table = ((New-Object System.Net.WebClient).DownloadString($URL) -split "`n")
    $startLine = $raw_Table.IndexOf('| Product name | String ID | GUID | Service plans included | Service plans included (friendly names) |')
    $endLine = ($raw_Table.IndexOf('## Service plans that cannot be assigned at the same time') - 1)
    $result = @()
    for ($i = $startLine; $i -lt $endLine; $i++) {
        if ($raw_Table[$i] -notlike "*---*") {
            $result += ($raw_Table[$i].Substring(1, $raw_Table[$i].Length - 1))
        }
    }
    $result = $result `
        -replace '\s*\|\s*', '|' `
        -replace '\s*<br/>\s*', ',' `
        -replace '\(\(', '(' `
        -replace '\)\)', ')' `
        -replace '\)\s*\(', ')('
    $result = @($result | ConvertFrom-Csv -Delimiter "|" -Header 'SkuName', 'SkuPartNumber', 'SkuID', 'ChildServicePlan', 'ChildServicePlanName')
    $TextInfo = (Get-Culture).TextInfo
    $i = 0
    $result | ForEach-Object {
        $result[$i].SkuName = $TextInfo.ToTitleCase(($PSItem.SkuName).ToLower())
        $result[$i].ChildServicePlanName = $TextInfo.ToTitleCase(($PSItem.ChildServicePlanName).ToLower())
        $i++
    }
    $result
}
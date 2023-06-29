Function Update-NetboxDCIMSiteGroup {
    <#
        .SYNOPSIS
            Update a Site Group

        .DESCRIPTION
            Update a Site Group from Netbox

        .EXAMPLE
            Update-NetboxDCIMSiteGroup -Id 1 -name 'Updated Name' -slug 6969 -parent 5 -description 'New Description' -tags ?

            Update Tenant with id 1

        .EXAMPLE
            Get-NetboxDCIMSiteGroup -name MySiteGroup | Update-NetboxDCIMSiteGroup -confirm:$false

            Update Site Group with name MySiteGroup without confirmation

    #>

    [CmdletBinding(ConfirmImpact = 'low',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [uint32]$id,
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$name,
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$slug,
        [int]$parent,
        [string]$description,
        [uint16[]]$tags,
        [switch]$raw
    )
    begin {
    }
    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'site-groups'))
        $CurrentSiteGroup = Get-NetboxDCIMSiteGroup -Id $Id -ErrorAction Stop
        If (-not $PSBoundParameters.ContainsKey('slug')) {$PSBoundParameters.Add('slug', $CurrentSiteGroup.slug)}
        If (-not $PSBoundParameters.ContainsKey('name')) {$PSBoundParameters.Add('name', $CurrentSiteGroup.name)}

        $Method = 'PUT'

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters
        $URI = BuildNewURI -Segments $URIComponents.Segments

        If ($pscmdlet.ShouldProcess("$($CurrentSiteGroup.Id)", "Update Site Group")) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
    end {
    }
}
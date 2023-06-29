Function Update-NetboxTenant {
    <#
        .SYNOPSIS
            Update a Tenant

        .DESCRIPTION
            Update a Tenant from Netbox

        .EXAMPLE
            Update-NetboxTenant -Id 1 -name 'Updated Name' -slug 6969 -Group 5 -description 'New Description' -comments 'New Comment'  -tags ?

            Update Tenant with id 1

        .EXAMPLE
            Get-NetboxTenant -name MyTenant | Update-NetboxTenant -confirm:$false

            Update Tenant with name MyTenant without confirmation

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
        [int]$group,
        [string]$description,
        [string]$comments,
        [uint16[]]$tags,
        [switch]$raw
    )
    begin {
    }
    process {
        $Segments = [System.Collections.ArrayList]::new(@('tenancy', 'tenants'))
        $CurrentTenant = Get-NetboxTenant -Id $Id -ErrorAction Stop
        If (-not $PSBoundParameters.ContainsKey('slug')) {$PSBoundParameters.Add('slug', $CurrentTenant.slug)}
        If (-not $PSBoundParameters.ContainsKey('name')) {$PSBoundParameters.Add('name', $CurrentTenant.name)}

        $Method = 'PUT'

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters
        $URI = BuildNewURI -Segments $URIComponents.Segments

        If ($pscmdlet.ShouldProcess("$($CurrentTenant.Id)", "Update Tenant")) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
    end {
    }
}
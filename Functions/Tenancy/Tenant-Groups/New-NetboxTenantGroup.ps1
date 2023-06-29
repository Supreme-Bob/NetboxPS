function New-NetboxTenantGroup {
    <#
    .SYNOPSIS
        Create a new Tenant Group to Netbox

    .DESCRIPTION
        Create a new Tenant Group to Netbox

    .EXAMPLE
        New-NetboxTenantGroup -name MyGroup

        Add new Tenant Group MyGroup on Netbox

    #>

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$name,

        [string]$slug,

        [int]$parent,

        [string]$description,

        [uint16[]]$Tags,

        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('tenancy', 'tenant-groups'))
        $Method = 'POST'

        if (-not $PSBoundParameters.ContainsKey('slug')) {
            $PSBoundParameters.Add('slug', $name)
        }

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        if ($PSCmdlet.ShouldProcess($name, 'Create new Tenant Group')) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
}
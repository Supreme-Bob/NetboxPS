function Remove-NetboxTenantGroup {
    <#
        .SYNOPSIS
            Remove a Tenant Group

        .DESCRIPTION
            Remove a Tenant Group from Netbox

        .EXAMPLE
            Remove-NetboxTenantGroup -Id 1

            Remove Tenant Group with id 1

        .EXAMPLE
            Get-NetboxTenantGroup -name My Group | Remove-NetboxTenantGroup -confirm:$false

            Remove Tenant Group with name My Group without confirmation

    #>

    [CmdletBinding(ConfirmImpact = 'High',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [uint32]$Id

    )

    begin {

    }

    process {
        $CurrentSite = Get-NetboxTenantGroup -Id $Id -ErrorAction Stop

        if ($pscmdlet.ShouldProcess("$($CurrentSite.Name)/$($CurrentSite.Id)", "Remove Tenant Group")) {
            $Segments = [System.Collections.ArrayList]::new(@('tenancy', 'tenancy-groups', $CurrentSite.Id))

            $URI = BuildNewURI -Segments $Segments

            InvokeNetboxRequest -URI $URI -Method DELETE
        }
    }

    end {

    }
}
#endregion
function Remove-NetboxDCIMRegion {
    <#
        .SYNOPSIS
            Remove a Region

        .DESCRIPTION
            Remove a DCIM Region from Netbox

        .EXAMPLE
            Remove-NetboxDCIMRegion -Id 1

            Remove DCIM Region with id 1

        .EXAMPLE
            Get-NetboxDCIMRegion-name My Region | Remove-NetboxDCIMRegion -confirm:$false

            Remove DCIM Region with name My Region without confirmation

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
        $CurrentSite = Get-NetboxDCIMRegion -Id $Id -ErrorAction Stop

        if ($pscmdlet.ShouldProcess("$($CurrentSite.Name)/$($CurrentSite.Id)", "Remove Region")) {
            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'regions', $CurrentSite.Id))

            $URI = BuildNewURI -Segments $Segments

            InvokeNetboxRequest -URI $URI -Method DELETE
        }
    }

    end {

    }
}
function Remove-NetboxDCIMSiteGroup {
    <#
        .SYNOPSIS
            Remove a Site Group

        .DESCRIPTION
            Remove a DCIM Site Group from Netbox

        .EXAMPLE
            Remove-NetboxDCIMSiteGroup -Id 1

            Remove DCM Site Group with id 1

        .EXAMPLE
            Get-NetboxDCIMSiteGroup -name My Group | Remove-NetboxDCIMSiteGroup -confirm:$false

            Remove DCM Site Group with name My Group without confirmation

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
        $CurrentSite = Get-NetboxDCIMSiteGroup -Id $Id -ErrorAction Stop

        if ($pscmdlet.ShouldProcess("$($CurrentSite.Name)/$($CurrentSite.Id)", "Remove Site")) {
            $Segments = [System.Collections.ArrayList]::new(@('dcim', 'site-groups', $CurrentSite.Id))

            $URI = BuildNewURI -Segments $Segments

            InvokeNetboxRequest -URI $URI -Method DELETE
        }
    }

    end {

    }
}
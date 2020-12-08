﻿<#
    .SYNOPSIS
        A brief description of the Invoke-deploy_ps1 file.
    
    .DESCRIPTION
        A description of the file.
    
    .PARAMETER SkipVersion
        A description of the SkipVersion parameter.
    
    .PARAMETER VersionIncrease
        A description of the VersionIncrease parameter.
    
    .PARAMETER NewVersion
        A description of the NewVersion parameter.
    
    .NOTES
        ===========================================================================
        Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.174
        Created on:   	4/9/2020 09:43
        Created by:   	Claussen
        Organization: 	NEOnet
        Filename:     	deploy.ps1
        ===========================================================================
#>
[CmdletBinding(DefaultParameterSetName = 'IncreaseVersion')]
param
(
    [Parameter(ParameterSetName = 'SkipVersion')]
    [switch]$SkipVersion,
    
    [Parameter(ParameterSetName = 'IncreaseVersion')]
    [version]$VersionIncrease = "0.0.1",
    
    [Parameter(ParameterSetName = 'SetVersion')]
    [version]$NewVersion
)

Write-Host "Beginning deployment" -ForegroundColor Green

$ModuleName = 'NetboxPS'
$ConcatenatedFilePath = "$PSScriptRoot\concatenated.ps1"
$FunctionPath = "$PSScriptRoot\Functions"
$OutputDirectory = "$PSScriptRoot\$ModuleName"
$PSD1OutputPath = "$OutputDirectory\$ModuleName.psd1"
$PSM1OutputPath = "$OutputDirectory\$ModuleName.psm1"

$PS1Files = Get-ChildItem $FunctionPath -Filter "*.ps1" -Recurse | Sort-Object Name

"" | Out-File -FilePath $ConcatenatedFilePath -Encoding utf8

$Counter = 0
Write-Host "Concatenating [$($PS1Files.Count)] PS1 files from $FunctionPath"
foreach ($File in $PS1Files) {
    $Counter++
    
    try {
        Write-Host (" Adding file {0:D2}/{1:D2}: $($File.Name)" -f $Counter, $PS1Files.Count)
        
        "`r`n#region File $($File.Name)`r`n" | Out-File -FilePath $ConcatenatedFilePath -Encoding utf8 -Append
        
        Get-Content $File.FullName -Encoding UTF8 | Out-File -FilePath $ConcatenatedFilePath -Encoding utf8 -Append
        
        "`r`n#endregion" | Out-File -FilePath $ConcatenatedFilePath -Encoding utf8 -Append
    } catch {
        Write-Host "FAILED TO WRITE CONCATENATED FILE: $($_.Exception.Message): $($_.TargetObject)" -ForegroundColor Red
        return
    }
}

"" | Out-File -FilePath $ConcatenatedFilePath -Encoding utf8 -Append

Write-Host " Adding psm1"
Get-Content "$PSScriptRoot\$ModuleName.psm1" | Out-File -FilePath $ConcatenatedFilePath -Encoding UTF8 -Append

$PSDManifest = Import-PowerShellDataFile -Path "$PSScriptRoot\$ModuleName.psd1"
# Get the version from the PSD1
#[version]$CurrentVersion = [regex]::matches($PSDContent, "\s*ModuleVersion\s=\s'(\d*.\d*.\d*)'\s*").groups[1].value
[version]$CurrentVersion = $PSDManifest.ModuleVersion


switch ($PSCmdlet.ParameterSetName) {
    "SkipVersion" {
        # Dont do anything with the PSD
        Write-Host " Skipping version update, maintaining version [$CurrentVersion]"
        
        break
    }
    
    "IncreaseVersion" {
        # Calculate the new version
        [version]$NewVersion = "{0}.{1}.{2}" -f ($CurrentVersion.Major + $VersionIncrease.Major), ($CurrentVersion.Minor + $VersionIncrease.Minor), ($CurrentVersion.Build + $VersionIncrease.Build)
        
        Write-Host " Updating version in PSD1 from [$CurrentVersion] to [$NewVersion]"
        
        # Replace the version number in the content
        #$PSDContent -replace $CurrentVersion, $NewVersion | Out-File $PSScriptRoot\$ModuleName.psd1 -Encoding UTF8
        Update-ModuleManifest -Path "$PSScriptRoot\$ModuleName.psd1" -ModuleVersion $NewVersion
        
        break
    }
    
    "SetVersion" {
        Write-Host " Updating version in PSD1 from [$CurrentVersion] to [$NewVersion]"
        
        # Replace the version number in the content
        #$PSDContent -replace $CurrentVersion, $NewVersion | Out-File $PSScriptRoot\$ModuleName.psd1 -Encoding UTF8
        Update-ModuleManifest -Path "$PSScriptRoot\$ModuleName.psd1" -ModuleVersion $NewVersion
        
        break
    }
}


if (-not (Test-Path $OutputDirectory)) {
    try {
        Write-Warning "Creating path [$OutputDirectory]"
        $null = New-Item -Path $OutputDirectory -ItemType Directory -Force
    } catch {
        throw "Failed to create directory [$OutputDirectory]: $($_.Exception.Message)"
    }
}

Write-Host " Copying psd1"
Copy-Item -Path "$PSScriptRoot\$ModuleName.psd1" -Destination $PSD1OutputPath -Force

Write-Host " Copying psm1"
Copy-Item -Path $ConcatenatedFilePath -Destination $PSM1OutputPath -Force

Write-Host "Deployment complete" -ForegroundColor Green
<#
.SYNOPSIS
    Register-NugetPackageSource registers a Nuget packge source.
.DESCRIPTION
    Register-NugetPackageSource calls Register-PackageSource cmdlet to register a Nuget package source. 
.EXAMPLE
    Register-NugetPackageSource
    # This registers a Nuget package source when a user confirms (y)
#>

function Register-NugetPackageSource {
    [CmdletBinding()]
    param (
        # Used for unit testing
        [Parameter(DontShow)]
        [Switch]$Add
    )
    
    begin {
        $output = [PSCustomObject]@{
            PackageSourceName = ""
            Registered = $false
        }
        $packageSourceDefaultName = 'NuGetRepository'
    }
    
    process {
        if ($Add) {
            try {
                Register-PackageSource -Name $packageSourceDefaultName -Location $nugetSourceUri -ProviderName NuGet
                $output.PackageSourceName = $packageSourceDefaultName
                $output.Registered = $true
            } catch {
                Write-Log "Failed to register Nuget package source" -LogLevel ERROR
                Write-Log $_ -LogLevel ERROR
            }
        } else {
            $userInput = Read-Host "Would you like to register a Nuget package source? (Y/N)"
            if ($userInput.ToLower() -eq 'y') {
                Register-PackageSource -Name $packageSourceDefaultName -Location $nugetSourceUri -ProviderName NuGet
                $output.PackageSourceName = $packageSourceDefaultName
                $output.Registered = $true
            } else {
                Write-Log 'In order to install CDK packages from Nuget, register Nuget as a package source' -LogLevel WARN
                Write-Log "To register a Nuget package source, run Register-PackageSource -Name NugetRepository -Location $($nugetSourceUri) -ProviderName Nuget"
            }
        }
        return $output
    }
    
    end {
    }
}
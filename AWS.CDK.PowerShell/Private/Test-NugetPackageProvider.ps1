<#
.SYNOPSIS
    Test-NugetPackageProvider checks if Nuget package provider is added to the list of package providers
.DESCRIPTION
    Test-NugetPackageProvider calls Get-PackgeProvider to check if Nuget is added to the package provider list. 
    If -Add parameter is used, this registers Nuget as a new package provider. 
    Nuget is required to install CDK packages.
.EXAMPLE
    Test-NugetPackageProvider -Add
    # This tests if Nuget is added. If not, register Nuget as a package provider. 
#>

function Test-NugetPackageProvider {
    [CmdletBinding()]
    param ()
    
    begin {
        $output = [PSCustomObject]@{
            Provider = "Nuget"
            Registered = $false
        }
        $troubleshootLink = 'https://learn.microsoft.com/en-us/powershell/scripting/gallery/how-to/getting-support/bootstrapping-nuget?view=powershell-7.2#resolving-error-when-the-nuget-provider-has-not-been-installed-on-a-machine-that-is-internet-connected'
    }
    
    process {
        # https://learn.microsoft.com/en-us/powershell/scripting/gallery/how-to/getting-support/bootstrapping-nuget?view=powershell-7.2
        # Starting with version 6, the NuGet provider is included in the installation of PowerShell.
        $packageProviderExist = Get-PackageProvider -Name Nuget
        if ($null -eq $packageProviderExist)  {
            Write-Log 'Nuget package provider not found. Please register Nuget as a package provider' -LogLevel ERROR
            Write-Log "Refer to the troubleshooting guide to install Nuget provider: $troubleshootLink" -LogLevel WARN 
        } else {
            $output.Registered = $true
        }
        return $output
    }
    
    end {
    }
}
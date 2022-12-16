<#
.SYNOPSIS
    Invoke-NugetVerify invokes nuget verify cli command.
.DESCRIPTION
    Invoke-NugetVerify invokes nuget verify cli command.
.EXAMPLE
    Invoke-NugetVerify -PackagePath C:\users\test\cdkpath\packages\dummy.0.0.0
    # Verify the nuget package's signature for dummy package for the version 0.0.0
#>

function Invoke-NugetVerify {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $PackagePath
    )
    
    begin {
    }
    
    process {
        # https://learn.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-verify
        # Run a nuget cli command to verify
        if (($IsLinux) -or ($IsMacOS)){
            # https://learn.microsoft.com/en-us/nuget/install-nuget-client-tools#macoslinux
            # https://github.com/dotnet/core/issues/7688
            # On linux, nuget package verification is not supported without opt-in.
            Write-Log "nuget package verification is not supported on this platform" -LogLevel WARN
        } else {
            $nugetCommand = ("& nuget verify -Signatures {0}\*.nupkg" -f $PackagePath)
        }
        $output = Invoke-Expression -Command $nugetCommand
        return $output
    }
    end {
    }
}
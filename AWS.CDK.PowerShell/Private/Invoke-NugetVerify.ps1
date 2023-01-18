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
        $output = ""
        # https://learn.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-verify
        # Run a nuget cli command to verify
        if (($IsLinux) -or ($IsMacOS)){
            # https://learn.microsoft.com/en-us/nuget/install-nuget-client-tools#macoslinux
            # https://github.com/dotnet/core/issues/7688
            # On linux, nuget package verification is not supported without opt-in.
            Write-Log "nuget package verification is not supported on this platform" -LogLevel WARN
        } else {
            $nugetCommand = ("& nuget verify -Signatures {0}\*.nupkg" -f $PackagePath)
            # Invoke the nuget verify command to check the nuget signature
            try {
                $output = Invoke-Expression -Command $nugetCommand
            } catch [System.Management.Automation.CommandNotFoundException] {
                Write-Log "nuget command is not found. Install nuget CLI and add the path to `$env:PATH" -LogLevel ERROR
                Write-Log "nuget CLI installation reference: https://learn.microsoft.com/en-us/nuget/reference/nuget-exe-cli-reference" -LogLevel WARN
                throw
            }
        }
        return $output
    }
    end {
    }
}
<#
.SYNOPSIS
    Write-Log writes a log output (stdout)
.DESCRIPTION
    Write-Log is a helper function used in the module to write a log output.
.EXAMPLE
    Write-Log -Message "test message" -LogLevel "ERROR"
    # Sample output: [2022-08-31T12:48:24.8212396-04:00] [ERROR] test message
#>

function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Message,
        [ValidateSet('INFO','WARN', 'ERROR', 'DEBUG')]
        $LogLevel = 'INFO'
        )
    begin {
    }
    
    process {
        $timestamp = Get-Date -Format o
        Write-Host ("[{0}] [{1}] {2}" -f $timestamp, $LogLevel, $Message)
    }
    
    end {
    }
}
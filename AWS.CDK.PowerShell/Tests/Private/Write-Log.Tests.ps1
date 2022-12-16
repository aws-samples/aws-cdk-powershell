param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

InModuleScope 'AWS.CDK.PowerShell' {
    Describe 'Write-Log' {
        BeforeAll {
        }
        It 'Tests a message' {
            $testMessage = "test"
            $testDateString = (Get-Date -Format yyyy-MM-ddT).ToString()
            Write-Log -Message $testMessage -LogLevel INFO -InformationVariable writeLogMessage
            # match date string
            $writeLogMessage -join " " | Should -Match $testDateString
            # match log level
            $writeLogMessage -join " " | Should -Match "[INFO]"
            # match log message
            $writeLogMessage -join " " | Should -Match $testMessage
        }
    }
}
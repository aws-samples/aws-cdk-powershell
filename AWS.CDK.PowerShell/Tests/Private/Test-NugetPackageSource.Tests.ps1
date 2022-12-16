param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

InModuleScope 'AWS.CDK.PowerShell' {
    Describe 'Test-NugetPackageSource' {
        # https://github.com/pester/Pester/issues/2213
        # there is an issue with mocking Get-PackageSource command which has dynamic parameter
    }
}
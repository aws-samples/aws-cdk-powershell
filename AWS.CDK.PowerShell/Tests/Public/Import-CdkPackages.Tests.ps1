param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

Describe 'Import-CdkPackages' {
    BeforeAll {
        New-Item -ItemType Directory -Name 'packages' -Path 'TestDrive:'
        $testPackagePath = "TestDrive:\packages"
        # $childPath = ("{0}/{1}.{2}/lib/{3}/{4}.dll" -f $DependencyDirectoryName, $package.Name, $package.Version, $package.Framework, $package.Name)
        $mockPackages = @(
            [PSCustomObject]@{
                # https://www.nuget.org/packages/Amazon.CDK.Lib
                'Name' = 'Amazon.CDK.Lib'
                'Version' = '2.37.1'
                'Framework' = 'netcoreapp3.1'
            }
        )
        Mock Add-Type -ModuleName 'AWS.CDK.PowerShell' { return $null }
        Mock Resolve-Path { return $null }
    }
    It 'Throws an exception when an invalid package directory is passed' {
        { Import-CdkPackages -CdkDirectory 'invalid path ...' } | Should -Throw
    }
    It 'Passes an invalid package file name under valid paths' {
        Import-CdkPackages -CdkDirectory 'TestDrive:\packages' -TargetPackages $mockPackages | Should -BeNullOrEmpty
    }
    It 'Imports a module successfully' {
        $importCdkOutput = Import-CdkPackages -CdkDirectory 'TestDrive:\packages' -TargetPackages $mockPackages
        $importCdkOutput | Should -BeNullOrEmpty
    }
}

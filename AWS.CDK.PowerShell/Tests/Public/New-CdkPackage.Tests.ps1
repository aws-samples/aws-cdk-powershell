param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

Describe 'New-CdkPackage' {
    BeforeAll {
        Mock Install-CdkPackage { return $null }
        Mock ForEach-Object { return $null }
        $defaultCdkJsonFileName = 'cdk.json'
        $testDrive = "TestDrive:\"
        $defaultDirectoryPrefix = 'cdk-powershell'
    }
    It 'Passes an invalid path' {
        { New-CdkPackage -Path 'invalid path ...' } | Should -Throw
    }
    It 'Passes an invalid template name' {
        { New-CdkPackage -Path $testDrive -Template 'dummy' } | Should -Throw
    }
    It 'Sets a custom name' {
        $customName = 'pester'
        New-CdkPackage -Path $testDrive -Name $customName -SkipPackageInstallation
        $appScriptName = 'default-app.ps1'
        $appTestName = 'default-app.Tests.ps1'
        $customNameFiles = Get-ChildItem (Join-Path -Path $testDrive -ChildPath $customName)
        $customNameFiles.Name | Should -Contain $defaultCdkJsonFileName
        $customNameFiles.Name | Should -Contain $appScriptName
        $customNameFiles.Name | Should -Contain $appTestName
    }
    It 'Blank template' {
        New-CdkPackage -Path $testDrive -Template blank -SkipPackageInstallation
        $appScriptName = 'default-app.ps1'
        $appTestName = 'default-app.Tests.ps1'
        $customNameFiles = Get-ChildItem (Join-Path -Path $testDrive -ChildPath $defaultDirectoryPrefix)
        $customNameFiles.Name | Should -Contain $defaultCdkJsonFileName
        $customNameFiles.Name | Should -Contain $appScriptName
        $customNameFiles.Name | Should -Contain $appTestName
    }
    It 'EC2 template' {
        New-CdkPackage -Path $testDrive -Template ec2 -SkipPackageInstallation
        $appScriptName = 'ec2-app.ps1'
        $appTestName = 'ec2-app.Tests.ps1'
        $customNameFiles = Get-ChildItem (Join-Path -Path $testDrive -ChildPath "$($defaultDirectoryPrefix)-ec2")
        $customNameFiles.Name | Should -Contain $defaultCdkJsonFileName
        $customNameFiles.Name | Should -Contain $appScriptName
        $customNameFiles.Name | Should -Contain $appTestName
    }
    It 'S3 template' {
        New-CdkPackage -Path $testDrive -Template s3 -SkipPackageInstallation
        $appScriptName = 's3-app.ps1'
        $appTestName = 's3-app.Tests.ps1'
        $customNameFiles = Get-ChildItem (Join-Path -Path $testDrive -ChildPath "$($defaultDirectoryPrefix)-s3")
        $customNameFiles.Name | Should -Contain $defaultCdkJsonFileName
        $customNameFiles.Name | Should -Contain $appScriptName
        $customNameFiles.Name | Should -Contain $appTestName
    }
    It 'Serverless template' {
        New-CdkPackage -Path $testDrive -Template serverless -SkipPackageInstallation
        $appScriptName = 'serverless-app.ps1'
        $appTestName = 'serverless-app.Tests.ps1'
        $customNameFiles = Get-ChildItem (Join-Path -Path $testDrive -ChildPath "$($defaultDirectoryPrefix)-serverless")
        $customNameFiles.Name | Should -Contain $defaultCdkJsonFileName
        $customNameFiles.Name | Should -Contain $appScriptName
        $customNameFiles.Name | Should -Contain $appTestName
    }
    It 'Throws a file creation failure' {
        Mock New-Item -ModuleName AWS.CDK.PowerShell { throw 'failing on purpose' }
        { New-CdkPackage -Path $testDrive } | Should -Throw 
    }
}

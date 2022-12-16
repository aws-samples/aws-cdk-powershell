#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }

BeforeAll {
    # Use #Requires AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell
    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory $PSScriptRoot

    # Dot source the app file
    . .\s3-app.ps1
}
# This unit test uses Pester for testing framework and Amazon.CDK.Assertions to assert against CDK applications.
# https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.html
# https://docs.aws.amazon.com/cdk/v2/guide/testing.html
Describe "AWS CDK S3 App" {
    Context 'New-CdkApp' {
        It 'Returns an Amazon.CDK.App object' {
            $testApp = New-CdkApp
            $testApp | Should -BeOfType ([Amazon.CDK.App])
        }
    }
    Context 'New-CdkStack' {
        It 'Returns an Amazon.CDK.Stack object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $testStack | Should -BeOfType ([Amazon.CDK.Stack])
        }
    }
    Context 'New-CdkS3BucketDefaultProps' {
        It 'Returns an Amazon.CDK.AWS.S3.BucketProps object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $s3Props = New-CdkS3BucketDefaultProps
            $s3Props | Should -BeOfType ([Amazon.CDK.AWS.S3.BucketProps])
        }
    }
    Context "New-CdkS3Bucket" {
        BeforeAll {}
        It 'Has AWS::S3::Bucket resource with default settings' {
            # Instantiate an S3 bucket object through New-CdkS3Bucket function
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $s3Props = New-CdkS3BucketDefaultProps
            $s3Bucket = New-CdkS3Bucket -Props $s3Props -S3BucketResourcename 'test-bucket' -Stack $testStack
            $template = [Amazon.CDK.Assertions.Template]::FromStack($testStack)

            $s3TestProps = New-Object "System.Collections.Generic.Dictionary[String,Object]"

            # BlockPublicAccess
            $s3BlockPublicAcls = New-Object "System.Collections.Generic.Dictionary[String,Bool]"
            $s3BlockPublicPolicy = New-Object "System.Collections.Generic.Dictionary[String,Bool]"
            $s3IgnorePublicAcls = New-Object "System.Collections.Generic.Dictionary[String,Bool]"
            $s3RestrictPublicBuckets = New-Object "System.Collections.Generic.Dictionary[String,Bool]"

            $s3BlockPublicAcls.Add("BlockPublicAcls", $true)
            $s3TestProps.Add("PublicAccessBlockConfiguration", $s3BlockPublicAcls)
            $s3TestProps.PublicAccessBlockConfiguration.Add('BlockPublicPolicy', $true)
            $s3TestProps.PublicAccessBlockConfiguration.Add("IgnorePublicAcls", $true)
            $s3TestProps.PublicAccessBlockConfiguration.Add("RestrictPublicBuckets", $true)

            # BucketEncryption
            $s3BucketEncryption = New-Object "System.Collections.Generic.Dictionary[String,Object]"
            $s3ServerSideEncryptionConfiguration = New-Object "System.Collections.Generic.Dictionary[String,Array]"
            $s3ServerSideEncryptionByDefault = New-Object "System.Collections.Generic.Dictionary[String,String]"
            $s3ServerSideEncryptionByDefault.Add("SSEAlgorithm", "AES256")
            $s3ServerSideEncryptionConfiguration.Add("ServerSideEncryptionConfiguration", $s3ServerSideEncryptionByDefault)
            $s3BucketEncryption.Add("BucketEncryption", $s3ServerSideEncryptionConfiguration)

            # LoggingConfiguration
            $s3LoggingTest = New-Object "System.Collections.Generic.Dictionary[String,String]"
            $s3LoggingTest.Add("LogFilePrefix", "logs")
            $s3TestProps.Add("LoggingConfiguration", $s3LoggingTest)

            # VersioningConfiguration
            $s3VersioningConfiguration = New-Object "System.Collections.Generic.Dictionary[String,String]"
            $s3VersioningConfiguration.Add("Status", "Enabled")
            $s3TestProps.Add("VersioningConfiguration", $s3VersioningConfiguration)

            # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.Template.html#Amazon_CDK_Assertions_Template_HasResourceProperties_System_String_System_Object_
            $template.HasResourceProperties('AWS::S3::Bucket', $s3TestProps)
        }
    }
}
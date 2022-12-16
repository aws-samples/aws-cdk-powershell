#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }

BeforeAll {
    # Use #Requires AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell
    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory $PSScriptRoot

    # Dot source the app file
    . .\ec2-app.ps1
}
# This unit test uses Pester for testing framework and Amazon.CDK.Assertions to assert against CDK applications.
# https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.html
# https://docs.aws.amazon.com/cdk/v2/guide/testing.html
Describe "AWS CDK EC2 App" {
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
    Context 'New-CdkVpcDefaultProps' {
        It 'Returns an Amazon.CDK.AWS.S3.BucketProps object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $vpcProps = New-CdkVpcDefaultProps
            $vpcProps | Should -BeOfType ([Amazon.CDK.AWS.EC2.VpcProps])
        }
    }
    Context "New-CdkVpc" {
        BeforeAll {}
        It 'Has AWS::EC2::VPC resource with default settings' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $vpcProps = New-CdkVpcDefaultProps
            $vpc = New-CdkVpc -VpcProps $vpcProps -VpcResouceName 'test-vpc' -Stack $testStack
            $template = [Amazon.CDK.Assertions.Template]::FromStack($testStack)

            # VPC test
            $vpcTestProps = New-Object "System.Collections.Generic.Dictionary[String,Object]"

            # DNS Settings
            $vpcTestProps.Add("EnableDnsHostnames", $true)
            $vpcTestProps.Add("EnableDnsSupport", $true)

            # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.Template.html#Amazon_CDK_Assertions_Template_HasResourceProperties_System_String_System_Object_
            $template.HasResourceProperties('AWS::EC2::VPC', $vpcTestProps)
        }
    }
    Context "New-CdkEc2InstanceDefaultProps" {
        BeforeAll {}
        It 'Returns an Amazon.CDK.AWS.EC2.InstanceProps object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $vpcProps = New-CdkVpcDefaultProps
            $vpc = New-CdkVpc -VpcProps $vpcProps -VpcResouceName 'test-vpc' -Stack $testStack
            $ec2Props = New-CdkEc2InstanceDefaultProps -Vpc $vpc
            $ec2Props | Should -BeOfType ([Amazon.CDK.AWS.EC2.InstanceProps])
        }
    }
    Context "New-CdkEC2Instance" {
        BeforeAll {}
        It 'Has AWS::EC2::Instance resource with default settings' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $vpcProps = New-CdkVpcDefaultProps
            $vpc = New-CdkVpc -VpcProps $vpcProps -VpcResouceName 'test-vpc' -Stack $testStack
            $ec2Props = New-CdkEc2InstanceDefaultProps -Vpc $vpc
            $instance = New-CdkEC2Instance -EC2InstanceProps $ec2Props -EC2InstanceResourceName 'test-instance' -Stack $testStack
            $template = [Amazon.CDK.Assertions.Template]::FromStack($testStack)

            # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.Template.html#Amazon_CDK_Assertions_Template_HasResourceProperties_System_String_System_Object_
            $template.ResourceCountIs('AWS::EC2::Instance', 1)
        }
    }
}
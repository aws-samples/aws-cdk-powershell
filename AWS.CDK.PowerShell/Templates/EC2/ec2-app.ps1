# This is an AWS CDK EC2 app code in PowerShell

param (
    [Parameter(DontShow)]
    [Switch]
    $Test,
    # EC2ResourceName, VpcResourceName, and CdkStackName parameters can be specified under app in cdk.json
    # "app": "pwsh unittest-app.ps1 -EC2ResourceName test -VpcResourceName vpc -CdkStackName test-stack"
    [Parameter()]
    [String]$EC2ResourceName = 'aws-cdk-powershell-ec2-instance',
    [Parameter()]
    [String]$VpcResourceName = 'aws-cdk-powershell-vpc',
    [Parameter()]
    [String]$CdkStackName = 'aws-cdk-powershell-ec2'
)

function New-CdkApp {
    [OutputType([Amazon.CDK.App])]
    param ()
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.App.html
    [Amazon.CDK.App]$app = New-Object Amazon.CDK.App -ArgumentList @($null)
    return [Amazon.CDK.App]$app 
    
}

function New-CdkStack {
    [OutputType([Amazon.CDK.Stack])]
    param (
        [Amazon.CDK.App]$App, 
        [String]$Name
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Stack.html
    [Amazon.CDK.Stack]$stack = New-Object Amazon.CDK.Stack -ArgumentList([Amazon.CDK.App]$App, $Name)
    return [Amazon.CDK.Stack]$stack 
}

function New-CdkVpcDefaultProps {
    [OutputType([Amazon.CDK.AWS.EC2.VpcProps])]
    param ()
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.EC2.VpcProps.html
    $vpcProps = New-Object Amazon.CDK.AWS.EC2.VpcProps -Property @{
        # Set properties as needed
        EnableDnsHostnames = $true
        EnableDnsSupport = $true
        MaxAzs = 3
        VpcName = 'aws-cdk-powershell-vpc'
    }
    return [Amazon.CDK.AWS.EC2.VpcProps]$vpcProps
}


function New-CdkVpc {
    [OutputType([Amazon.CDK.AWS.EC2.Vpc])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.EC2.VpcProps]$VpcProps,
        [String]$VpcResouceName = 'default-cdk-powershell-vpc', 
        [Parameter(Mandatory)]
        [Amazon.CDK.Stack]$Stack
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.EC2.Vpc.html
    $vpc = New-Object Amazon.CDK.AWS.EC2.Vpc -ArgumentList ($Stack, $VpcResouceName, $VpcProps)
    return [Amazon.CDK.AWS.EC2.Vpc]$vpc
}


function New-CdkEc2InstanceDefaultProps {
    [OutputType([Amazon.CDK.AWS.EC2.InstanceProps])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.EC2.Vpc]$Vpc
    )
    $instanceProps = New-Object Amazon.CDK.AWS.EC2.InstanceProps -Property @{
        Vpc = $Vpc
        InstanceType = 't2.micro'
        # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.EC2.MachineImage.html
        # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.EC2.WindowsVersion.html
        MachineImage = [Amazon.CDK.AWS.EC2.MachineImage]::LatestWindows([Amazon.CDK.AWS.EC2.WindowsVersion]::WINDOWS_SERVER_2022_ENGLISH_FUll_BASE)
    }
    return [Amazon.CDK.AWS.EC2.InstanceProps]$instanceProps
}

function New-CdkEC2Instance {
    [OutputType([Amazon.CDK.AWS.EC2.Instance_])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.EC2.InstanceProps]$EC2InstanceProps,
        [String]$EC2InstanceResourceName = 'default-cdk-powershell-ec2',
        [Parameter(Mandatory)]
        [Amazon.CDK.Stack]$Stack
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.EC2.Instance_.html
    $ec2Instance = New-Object Amazon.CDK.AWS.EC2.Instance_ -ArgumentList ($stack, $Ec2InstanceResourceName, $EC2InstanceProps)
    return [Amazon.CDK.AWS.EC2.Instance_]$ec2Instance
}


function main {
    # Use #Require AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell

    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory  $PSScriptRoot  
    
    # Create Cdk constructs
    [Amazon.CDK.App]$cdkApp = New-CdkApp
    [Amazon.CDK.Stack]$cdkStack = New-CdkStack -App $cdkApp -Name $CdkStackName
    [Amazon.CDK.AWS.EC2.VpcProps]$vpcProps = New-CdkVpcDefaultProps
    [Amazon.CDK.AWS.EC2.Vpc]$vpc = New-CdkVpc -VpcProps $vpcProps -Stack $cdkStack -VpcResouceName $VpcResourceName
    [Amazon.CDK.AWS.EC2.InstanceProps]$instanceProps = New-CdkEc2InstanceDefaultProps -Vpc $vpc
    [Amazon.CDK.AWS.EC2.Instance_]$instance = New-CdkEC2Instance -EC2InstanceProps $instanceProps -EC2InstanceResourceName $EC2ResourceName -Stack $cdkStack

    # Call synth() to synthesize a template
    $cdkApp.synth()
}

if (!($Test)) {
    main
}
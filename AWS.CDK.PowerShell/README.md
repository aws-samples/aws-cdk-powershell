# AWS.CDK.PowerShell Module

AWS.CDK.PowerShell module simplifies [AWS Cloud Development Kit (AWS CDK)](https://aws.amazon.com/cdk/) development experience for PowerShell developers. The AWS CDK is an open-source software development framework to define your cloud application resources using familiar programming languages.

## Prerequisites

- PowerShell 7.0 or later
- .NET 8.0 or later
- [Nuget cli](https://learn.microsoft.com/en-us/nuget/reference/nuget-exe-cli-reference)
- Pester 5.0.0 or later (for unit tests)

## Usage

```powershell
# Download the module
cd <Package Directory>
Import-Module AWS.CDK.PowerShell

# Create a new PowerShell CDK Package
New-CdkPackage -Path <CDK path> -Template <blank | ec2 | s3 | serverless>

# Within your template, you can use Import-CdkPackages to import dependencies
Import-CdkPackages -CdkDirectory <CDK package directory>
```

## Test

```powershell
cd <Tests directory>
.\Invoke-CdkPesterTests -ModulePath <Path to the module> -TestPath <Path to the Tests directory>
```

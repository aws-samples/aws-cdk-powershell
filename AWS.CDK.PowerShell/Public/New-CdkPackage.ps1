<#
.SYNOPSIS
    New-CdkPackage creates a new CDK package
.DESCRIPTION
    New-CdkPackage creates a new directory (default: cdk-powershell) under -Path.
    Under the new CDK directory, it creates cdk.json, app file, and app unit test file. 
.EXAMPLE
    New-CdkPackage -Path C:\Users\test\sample-app -Template ec2
    # This creates a new directory under the specified path
    # For ec2 template, it creates cdk.json, ec2-app.ps1, and ec2-app.Tests.ps1
#>

function New-CdkPackage {
    [CmdletBinding()]
    # [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
            if(Test-Path $_){
                $true
            } else {
                throw "Path $_ is not valid"
            }})
        ]
        [String]$Path,
        [Parameter()]
        [String]$Name = "cdk-powershell",
        [Parameter()]
        [ValidateSet('blank', 'ec2', 's3', 'serverless')]
        [String]$Template = 'blank',
        [Parameter(DontShow)]
        [Switch]$SkipPackageInstallation
    )
    
    begin {
        $cdkFileName = "cdk.json"
        Write-Verbose ("cdk file name {0}" -f $cdkFileName)
        # only when Name is set as the default value
        if ($Name -eq "cdk-powershell") {
            switch ($Template) {
                ec2 {
                    $Name = $Name + "-ec2"
                }
                s3 {
                    $Name = $Name + "-s3"
                }
                serverless { 
                    $Name = $Name + "-serverless"
                }
            }
            Write-Verbose ("Default file name is selected" -f $Name)
        }
        $Path = (Resolve-Path $Path).Path
        $packagePath = Join-Path -Path $Path -ChildPath $Name
        $postCreationMessage = @"
######################################
To start developing the CDK app, go to $packagePath.
######################################
"@
        Write-Log 'Creating a new CDK package'
        Write-Log ("{0} template selected" -f $Template)
    }
    process {
        try {
            # Create a CDK package directory and CDK files
            New-Item -ItemType Directory -Path $Path -Name $Name | Out-Null
            $packageDirectoryPath = Join-Path -Path $Path -ChildPath $Name
            Write-Log ("CDK package directory {0}" -f $packageDirectoryPath)
            # cdk.json
            $templatesContent.$Template.cdk | Out-File -FilePath ("{0}\{1}" -f $packagePath, $cdkFileName)
            Write-Log ("Created {0} under {1}" -f $cdkFileName, $packagePath)
            # app file
            $templatesContent.$Template.script | Out-File -FilePath ("{0}\{1}" -f $packagePath, $availableTemplates.$Template.script)
            Write-Log ("Created {0} under {1}" -f $availableTemplates.$Template.script, $packagePath)
            # unit test
            $templatesContent.$Template.test | Out-File -FilePath ("{0}\{1}" -f $packagePath, $availableTemplates.$Template.test)
            Write-Log ("Created {0} under {1}" -f $availableTemplates.$Template.test, $packagePath)
            # Install CDK packages
            if (!($SkipPackageInstallation)){
                Write-Log ("Downloading CDK dependencies under {0}" -f (Join-Path -Path $packagePath -ChildPath packages))
                $packages | ForEach-Object { Install-CdkPackage -CdkDirectory $packagePath -PackageName $_.Name -PackageVersion $_.Version -OutVariable packageInstalled | Out-Null } 
            }
            Write-Host $postCreationMessage
        }
        catch {
            Write-Log "Unexpected error" -LogLevel 'ERROR'
            throw $_
        }
    }
    end {
    }
}
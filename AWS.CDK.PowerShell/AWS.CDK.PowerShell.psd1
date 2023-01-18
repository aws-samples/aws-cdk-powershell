#
# Module manifest for module 'AWS.CDK.PowerShell'
#

@{
    # Script module or binary module file associated with this manifest
    RootModule = 'AWS.CDK.PowerShell.psm1'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # Version number of this module.
    ModuleVersion = '1.0.1'

    # ID used to uniquely identify this module
    GUID = 'd203f79a-2b3d-4a6e-8003-35274f5e981d'

    # Author of this module
    Author = 'Amazon Web Services, Inc'

    # Company or vendor of this module
    CompanyName = 'Amazon Web Services, Inc'

    # Copyright statement for this module
    Copyright = 'Copyright Amazon Web Services, Inc. or its affiliates. All Rights Reserved.'

    # Description of the functionality provided by this module
    Description = 'The AWS.CDK.PowerShell module provides functions to simplify AWS CDK in PowerShell development.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Name of the PowerShell host required by this module
    PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module.
    RequiredAssemblies = @( )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @( )

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @( )

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @( )

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @( )

    # Functions to export from this module
    FunctionsToExport = @(
        'Import-CdkPackages',
        'Install-CdkPackage',
        'New-CdkPackage'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @( )

    # Variables to export from this module
    VariablesToExport = @("*")

    # Aliases to export from this module
    AliasesToExport = @( )

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @( )

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = @{

        PSData = @{
            Tags = @('AWS', 'cloud', 'CDK')
            LicenseUri = 'https://aws.amazon.com/apache-2-0/'
            ProjectUri = ''
            IconUri = ''
            ReleaseNotes = ''
        }
    }
}
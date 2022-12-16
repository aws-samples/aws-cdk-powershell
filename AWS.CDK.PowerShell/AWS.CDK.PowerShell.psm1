# Defining global variables
################################################
# nuget provider uri
$nugetSourceUri = "https://www.nuget.org/api/v2"

# packages files
$packages = . "$PSScriptRoot\Config\packages.ps1"

# template files
. "$PSScriptRoot\Config\templates.ps1"

$templateNames = @('blank', 'ec2', 's3', 'serverless')

foreach($templateName in $templateNames) {
    $templatesContent.$templateName.script = Get-Content ("{0}\Templates\{1}\{2}" `
        -f $PSScriptRoot, $availableTemplates.$templateName.name, $availableTemplates.$templateName.script)
    $templatesContent.$templateName.cdk = Get-Content ("{0}\Templates\{1}\{2}" `
        -f $PSScriptRoot, $availableTemplates.$templateName.name, $availableTemplates.$templateName.cdk)
    $templatesContent.$templateName.test = Get-Content ("{0}\Templates\{1}\{2}" `
        -f $PSScriptRoot, $availableTemplates.$templateName.name, $availableTemplates.$templateName.test)
}

$exportedVariables = @("nugetSourceUri", "packages", "availableTemplates", "templatesContent")
################################################

# Get public and private function definition files.
################################################
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
################################################

# Dot source the files
################################################
Foreach ($import in @($Public + $Private )) {
    Try {
        . $import.FullName
        Export-ModuleMember -Function $Public.Basename
        Export-ModuleMember -Variable $exportedVariables
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
################################################
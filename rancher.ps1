Param (
    [Parameter(Mandatory = $true)]

    [string]
    $AzureTenantID,

    [string]
    $AzureSubscriptionID,

    [string]
    $ODLID,

    [string]
    $DeploymentID,

    [string]
    $InstallCloudLabsShadow,

    [string] 
    $SPID,

    [string]
    $SPSecretKey,

    [string]
    $AzureUserName,

    [string]
    $AzurePassword,

    [string]
    $trainerUserName,

    [string]
    $trainerUserPassword
  )

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append

Remove-Item C:\labfiles -recurse  -force


#unziping folder
New-Item -ItemType Directory -Force -Path C:\lab-files
$file = "C:\lab-files.zip"
$destination = "C:\lab-files"
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item)
}

#Import Common Functions
$path = pwd
$path=$path.Path
$commonscriptpath = "$path" + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

# Run Imported functions from cloudlabs-windows-functions.ps1

WindowsServerCommon
InstallCloudLabsShadow $ODLID $InstallCloudLabsShadow
CreateCredFile $AzureUserName $AzurePassword $AzureTenantID $AzureSubscriptionID $DeploymentID

SPtoAzureCredFiles $SPID $SPSecretKey


[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -Force
Enable-AzureRmAlias -Scope CurrentUser
Uninstall-AzureRm

Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -Verbose
choco feature enable -n allowGlobalConfirmation
choco install googlechrome -y -force
choco install firefox -y -force




$azureAplicationId ="$SPID"
$azureTenantId= "cefcb8e7-ee30-49b8-b190-133f1daafd85"
$azurePassword = ConvertTo-SecureString "$SPSecretKey" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

C:\test\dotnet-runtime-2.2.8-win-x64.exe /silent /install

#Get-ChildItem -Path "C:\test\tech-immersion-data-ai-master\lab-files" -Recurse |  Move-Item -Destination "C:\lab-files"
Get-ChildItem -Path "C:\test\tech-immersion-data-ai-master\environment-setup\ai\2\sample-forms" -Recurse |  Move-Item -Destination "C:\autofiles\forms"





Stop-Transcript

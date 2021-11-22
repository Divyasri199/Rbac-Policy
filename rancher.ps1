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
    $vmAdminUsername,

    [string]
    $trainerUserPassword
  )

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

#Import Common Functions
$path = pwd
$path=$path.Path
$commonscriptpath = "$path" + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

# Run Imported functions from cloudlabs-windows-functions.ps1

$trainerUserPassword = "Password.!!1"


WindowsServerCommon
InstallCloudLabsShadow $ODLID $InstallCloudLabsShadow
CreateCredFile $AzureUserName $AzurePassword $AzureTenantID $AzureSubscriptionID $DeploymentID

SPtoAzureCredFiles $SPID $SPSecretKey

Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

InstallAzPowerShellModule

$azureAplicationId ="$SPID"
$azureTenantId= "cefcb8e7-ee30-49b8-b190-133f1daafd85"
$azurePassword = ConvertTo-SecureString "$SPSecretKey" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal

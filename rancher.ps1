Param (
    [Parameter(Mandatory = $true)]

    [string]
    $AzureTenantID,

    [string]
    $AzureSubscriptionID,

    [string]
    $ODLID,

  
    [string]
    $InstallCloudLabsShadow,

    [string] 
    $SPID,

    [string]
    $SPSecretKey,

   
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

Function CreadFiles($AzureTenantID, $AzureSubscriptionID, $SPID, $SPSecretKey)
{
    
    New-Item -ItemType directory -Path C:\LabFiles -force

    Add-Content -Path "C:\LabFiles\my-azure.txt" -Value "AzureTenantID= $AzureTenantID" -PassThru
    Add-Content -Path "C:\LabFiles\my-azure.txt" -Value "AzureSubscriptionID= $AzureSubscriptionID" -PassThru
    Add-Content -Path "C:\LabFiles\my-azure.txt" -Value "Application(Client)ID= $SPID" -PassThru
    Add-Content -Path "C:\LabFiles\my-azure.txt" -Value "SecretKey= $SPSecretKey" -PassThru

    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "AzureTenantID", "$AzureTenantID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "AzureSubscriptionID", "$AzureSubscriptionID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "Application(Client)ID", "$SPID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "SecretKey", "$SPSecretKey"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    
    Copy-Item "C:\LabFiles\my-azure.txt" -Destination "C:\Users\Public\Desktop"
}

CreadFiles $AzureTenantID $AzureSubscriptionID $SPID $SPSecretKey
    
    
Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

InstallAzPowerShellModule


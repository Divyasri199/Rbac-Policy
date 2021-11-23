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
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("https://raw.githubusercontent.com/Divyasri199/Rbac-Policy/main/my-azure.txt","C:\LabFiles\my-azure.txt")
    New-Item -ItemType directory -Path C:\LabFiles -force


     (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "AzureTenantID", "$AzureTenantID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "AzuresubID", "$AzureSubscriptionID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "clientid", "$SPID"} | Set-Content -Path "C:\LabFiles\my-azure.txt"
    (Get-Content -Path "C:\LabFiles\my-azure.txt") | ForEach-Object {$_ -Replace "secret", "$SPSecretKey"} | Set-Content -Path "C:\LabFiles\my-azure.txt"


    Copy-Item "C:\LabFiles\my-azure.txt" -Destination "C:\Users\Public\Desktop"
}

CreadFiles $AzureTenantID $AzureSubscriptionID $SPID $SPSecretKey
    
    
Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

InstallAzPowerShellModule


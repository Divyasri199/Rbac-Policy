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

$WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("https://raw.githubusercontent.com/sumitmalik51/Rbac-Policy/main/my-azure.txt","C:\LabFiles\my-azure.txt")
    Copy-Item "C:\LabFiles\my-azure.txt" -Destination "C:\Users\Public\Desktop"
    
    
Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

InstallAzPowerShellModule


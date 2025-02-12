param (
    [string]$TargetVM,
    [string]$Username,
    [string]$Password,
    [string]$AppPoolName,
    [string]$ServiceAccount,
    [string]$ServicePassword,
    [string]$DotNetVersion
)

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)

Invoke-Command -ComputerName $TargetVM -Credential $cred -ScriptBlock {
    param ($AppPoolName, $ServiceAccount, $ServicePassword, $DotNetVersion)

    Import-Module WebAdministration

    if (Test-Path "IIS:\AppPools\$AppPoolName") {
        Write-Host "App Pool '$AppPoolName' already exists. Skipping creation."
    } else {
        New-WebAppPool -Name $AppPoolName
        Write-Host "App Pool '$AppPoolName' created successfully."
    }

    Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name processModel.identityType -Value 3
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name processModel.userName -Value $ServiceAccount
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name processModel.password -Value $ServicePassword
    Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name managedRuntimeVersion -Value $DotNetVersion

    Start-WebAppPool -Name $AppPoolName

    Write-Host "Application Pool '$AppPoolName' configured and started successfully."

} -ArgumentList $AppPoolName, $ServiceAccount, $ServicePassword, $DotNetVersion

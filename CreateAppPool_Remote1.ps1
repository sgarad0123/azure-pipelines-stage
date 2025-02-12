param (
    [string]$TargetServer,  # Remote server name or IP
    [string]$UserName,      # Username for authentication
    [string]$Password       # Password for authentication
)

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)

# Execute ipconfig remotely
Invoke-Command -ComputerName $TargetServer -Credential $cred -Authentication Credssp -ScriptBlock {
    Write-Host "Fetching IP Configuration for $env:COMPUTERNAME"
    ipconfig /all
} | Out-File "C:\ADO2\ipconfig_output_$TargetServer.txt"

Write-Host "IP configuration saved to C:\ADO2\ipconfig_output_$TargetServer.txt"

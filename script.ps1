$password = ConvertTo-SecureString "9403" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("shubham", $password)
New-SSHSession -ComputerName "DESKTOP-8R1FAH3" -Credential $credential


# Optionally, run a command on the remote system
Invoke-SSHCommand -Index 0 -Command "echo 'mc' "

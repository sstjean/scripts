#agent-install.ps1
param(
    [string]$agentFolderPath,
    [string]$serverURL,
    [string]$agentPool,
    [string]$pat
)

Write-Host "Agent folder path: $agentFolderPath"
Write-Host "Server URL: $serverURL"
Write-Host "Agent Pool: $agentPool"
Write-Host "PAT: $pat"
Write-Host "Config command: $agentFolderPath\config.cmd"
Write-Host "Run command: $agentFolderPath\run.cmd"

#Prep the landing zone
Remove-Item $agentFolderPath -Recurse -Force -ErrorAction SilentlyContinue
mkdir $agentFolderPath  
cd $agentFolderPath

#Pull the binaries
Invoke-WebRequest https://vstsagentpackage.azureedge.net/agent/2.165.2/vsts-agent-win-x64-2.165.2.zip -OutFile $agentFolderPath\agent.zip
Add-Type -AssemblyName System.IO.Compression.FileSystem 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$agentFolderPath\agent.zip", $agentFolderPath)

#Configure
& "$agentFolderPath\config.cmd" --unattended --url $serverURL --auth pat --token $pat --pool $agentPool --replace --runAsService

#Launch
& "$agentFolderPath\run.cmd"
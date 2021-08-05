Function New-VSCodeProfile {
    [CmdLetBinding()]
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $ProfileName
    )

    $profilesPath = "$env:USERPROFILE\.vscode\profiles"

    $newProfilePath = "$profilesPath\$ProfileName"
    
    New-Item -Path $newProfilePath -ItemType Directory | Out-Null
    
    $dataPath = "$newProfilePath\data"
    $extensionsPath = "$newProfilePath\extensions"
    
    New-Item -Path $dataPath -ItemType Directory | Out-Null
    New-Item -Path $extensionsPath -ItemType Directory | Out-Null
    
    $vsCodePath = 'C:\Program Files\Microsoft VS Code\Code.exe'

    $commandArguments = " --extensions-dir `"%userprofile%\.vscode\profiles\$ProfileName\extensions`""
    $commandArguments += " --user-data-dir `"%userprofile%\.vscode\profiles\$ProfileName\data`""
    
    Set-Shortcut -SourceExe $vsCodePath -DestinationPath "%userprofile%\Desktop\VS Code $ProfileName.lnk" -CommandArguments $commandArguments

    New-Item -Path "$dataPath/User" -ItemType Directory | Out-Null
    '{"telemetry.enableTelemetry": false}' | Out-File "$dataPath/User/settings.json" -Encoding utf8
}

# https://stackoverflow.com/a/9701907
function Set-Shortcut ( [string]$SourceExe, [string]$DestinationPath, [string]$CommandArguments){
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $SourceExe
    
    $CommandArguments
    
    $Shortcut.Arguments = $CommandArguments
    $Shortcut.IconLocation = '%USERPROFILE%\Downloads\imageonline-co-hueshifted.ico'
    
    $CommandArguments
    
    $Shortcut

    $Shortcut.Save()
}

Export-ModuleMember -Function New-VSCodeProfile

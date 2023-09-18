if (-not (Test-Path -Path '.\SLSettings.csv')) {
    Write-Output "SLSettings.csv not found. Writing settings file and defaulting to initial settings"

    #Contents of sample settings file.
    $sample = @(
        [pscustomobject]@{Setting="Game"; Value="Starfield"},
        [pscustomobject]@{Setting="Affinity"; Value="111"}
    )
    
    #Write out sample, opens location where example was written   
    $sample | Export-CSV -Path .\SLSettings.csv -NoTypeInformation
    Write-Output "SLSettings.csv created"
    $settings = $sample

} else {
    Write-Output "Settings file found, continuing exection"
    $settings = Import-CSV .\SLSettings.csv
}


#Baseline Values
$gameName = $settings[0].Value
$affOffset = [Convert]::ToInt32($settings[1].Value,2)


$method = 0
if (Test-Path ".\$gameName.exe"){
    $curLoc = ""
    $curName = $gameName
    $method = 3
} else {
    $game = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | % { Get-ItemProperty $_.PsPath } | Select DisplayName,InstallLocation | Sort-Object Displayname -Descending | Where Displayname -eq $gameName
    $method = 1
    if ($game -eq $null){
        $game = Get-ChildItem HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | % { Get-ItemProperty $_.PsPath } | Select DisplayName,InstallLocation | Sort-Object Displayname -Descending | Where Displayname -eq $gameName
        $method = 2
    }
    $curLoc = $game.InstallLocation
    $curName = $game.DisplayName
}

switch ($method) {
    0 {
        Write-Output "$gameName not found, please move to install directory"
        Pause
        Exit
    }
    1 {Write-Output "$gameName found in Uninstall registry using method 1, continuing..."}
    2 {Write-Output "$gameName found in Uninstall registry using method 2, continuing..."}
    3 {Write-Output "$gameName found in current directory, continuing..."}
}

$curExe = $curName + ".exe"

Write-Output "$curName found at $curLoc"

cd $curLoc
$test = Start-Process .\$curExe -PassThru

while( (Get-WmiObject Win32_process -Filter "name = '$curExe'") -eq $null ) {
  Write-Output "Sleeping while Starfield Starts"
  Start-Sleep -s 10
  cls
}

Write-Output "Starfield started, safety sleep for 10s"
Start-Sleep -s 10

$count = 0
$runProc = Get-Process $curName

$befAffinity = $runProc.ProcessorAffinity
$aftAffinity = $befAffinity

While ($befAffinity -ne ($aftAffinity + $affOffset) -and ($count -lt 4)) {
    Write-Output "Reducing affinity by '$affOffset'"
    $runProc.ProcessorAffinity=($runProc.ProcessorAffinity - $affOffset)

    Start-Sleep -s 5
    $runProc = Get-Process $curName
    $aftAffinity = $runProc.ProcessorAffinity
    $count ++
}

if ($count > 4){
    Write-Output "Affinity set failed, check administrator mode or try again"
} else if ($count = 0) {
	Write-Output "Affinity not changed"
} else {
    Write-Output "Affinity set correctly"
}

Start-Sleep -s 5

Write-Output "Success! closing in 10s"
Start-Sleep -s 10

exit
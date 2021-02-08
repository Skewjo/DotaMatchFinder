# I may want to use this line when I go to run this powershell script from another source
# (such as the chrome extenion's javascript):
# PowerShell.exe -windowstyle hidden { your script.. } - found here: 
# https://stackoverflow.com/questions/1802127/how-to-run-a-powershell-script-without-displaying-a-window#:~:text=I%20found%20out%20if%20you,window%20when%20the%20task%20runs.

# CHANGE THE VALUE BELOW IF YOU HAVE ADDITIONAL LAUNCH OPTIONS SET THROUGH YOUR STEAM CLIENT
$launchOptions = "-novid -console -high"

# FIND DOWNLOAD DIRECTORY
Write-Output("Looking for chrome download directory...")
$chromePreferences = Get-Content "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\preferences"
$downloadPreference = $chromePreferences | ConvertFrom-Json | Select-Object -Property "download" 
$downloadDirectory = $downloadPreference.download.default_directory
if($downloadDirectory) {
    Write-Output("User's default Chrome directory is set.")
}
else {
    Write-Output("User's default Chrome directory is not set. Using default location.")
    $downloadDirectory = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
}

# UNZIP FILE
Write-Output("`nUnzipping the replay file...")
# TODO: I'm not sure what happens here if there are multiple zipped demo files in this directory...
$demoFileName = Get-ChildItem -Path "$downloadDirectory\*.bz2"
Write-Output("Demo file found in '$demoFileName'.")

# TODO: get rid of git bash window Minimized/Hidden didn't work.
$gitBashStatus = Start-Process -WindowStyle Minimized -PassThru -Wait -FilePath "$env:PROGRAMFILES\Git\git-bash.exe" `
    -Args "$PSScriptRoot\unzip.sh $demoFileName"
$gitBashUnzipExitCode = $gitBashStatus.ExitCode
# TODO: look for how to get git bash exit codes and error messages.
<#
if ($gitBashUnzipExitCode -eq 0) {
    Write-Output("File unziped successfully.")
}
else {
    Write-Output("Error in GitBash: $gitBashUnzipExitCode")
}
#>
$fileNoExtension = [io.path]::GetFileNameWithoutExtension($demoFileName)

# FIND STEAM & DOTA INSTALL LOCATION
$steamRegistry = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam
# REPLACE THE FOLLOWING LINE WITH THE DIRECTORY ABOVE "steamapps" IF YOUR DOTA 2 INSTALLATION FOLDER
# IS NOT IN THE DEFAULT LOCATION(IN YOUR STEAM INSTALLATION DIRECTORY)
$steamInstallPath = $steamRegistry.InstallPath
#$steamInstallPath = "F:\SteamLibrary" # This is the path that I have to use...
$dotaReplayPath = "$steamInstallPath\steamapps\common\dota 2 beta\game\dota\replays"

# MOVE UNZIPPED FILE
Write-Output("`nLooking for the unzipped file in: '$dotaReplayPath'.")
if (Test-Path($dotaReplayPath)) {
    $moveItemOutput = Move-Item -Force -PassThru -Path $downloadDirectory\$fileNoExtension -Destination ("$dotaReplayPath\$fileNoExtension")
    if ($moveItemOutput.Exists) {
        Write-Output("File moved to '$dotaReplayPath\$fileNoExtension'.")
    }
}
else {
    Write-Output("Dota 2 installation directory not found in default location - please open this 
        script and change the path to the dota 2 replay directory.")
    #Implement Read-Host here & save their given path in some other kind of config file maybe?
}

# WRITE NEW AUTOEXEC TO PLAY DEMO AS SOON AS THE GAME STARTS UP
Write-Output("`nWriting execution script...")
$cfgPath ="$steamInstallPath\steamapps\common\dota 2 beta\game\dota\cfg"
$autoExec = "$cfgPath\autoexec.cfg"
$playDemo = "playdemo replays/$fileNoExtension"
if (!(Test-Path $autoExec)) {
    $_ = New-Item -path $cfgPath -name "autoexec.cfg" -type "file" -value $playDemo
    Write-Host "Created new cfg file and text content added."
}
else {
    Set-Content -path $autoExec -value $playDemo
    Write-Host "Cfg file already exists - file overwritten."
}

# RUN DOTA
Write-Output("`nStarting dota2...")
$dotaExe64 = "$steamInstallPath\steamapps\common\dota 2 beta\game\bin\win64\dota2.exe"
$dotaExe32 = "$steamInstallPath\steamapps\common\dota 2 beta\game\bin\win32\dota2.exe"
# Run 64Bit if it exists, otherwise run 32Bit
if (Test-Path $dotaExe64) {
    Write-Output("Running dota2 64Bit version.")
    Start-Process -Wait -FilePath $dotaExe64 -Args "$launchOptions -exec"
} 
else {
    Write-Output("Running dota2 32Bit version.")
    Start-Process -Wait -FilePath $dotaExe32 -Args "$launchOptions -exec"
}
# with the -Wait option, the powershell script will run until dota exits... not sure if I want that...

# delete the autoexec and replay after dota closes
Write-Output("`nDeleting execution script and replay...")
Remove-Item $autoExec
Remove-Item $dotaReplayPath\$fileNoExtension

Write-Output("`nDone!")
Pause # Leaving for troubleshooting because I always forget the name of the command
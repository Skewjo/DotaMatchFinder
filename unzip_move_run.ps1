#FIND DOWNLOAD DIRECTORY
$chromePreferences = Get-Content "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\preferences"
$downloadPreference = $chromePreferences | ConvertFrom-Json | Select-Object -Property "download" 
$downloadDirectory = $downloadPreference.download.default_directory
if($downloadDirectory){
    Write-Output("User's default Chrome directory is set.")
}
else{
    Write-Output("User's default Chrome directory is not set. Using default location.")
    $downloadDirectory = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path

}


#UNZIP FILE
#I'm not sure what happens here if there are multiple zipped demo files in this directory...
$demoFileName = Get-ChildItem -Path "$downloadDirectory\*.bz2"
Write-Output("Demo file found $demoFileName")
Start-Process -Wait -FilePath "$env:PROGRAMFILES\Git\git-bash.exe" -Args "D:\Users\Skewb\Documents\repos\DotaMatchFinder\unzip.sh $demoFileName"
$fileNoExtension = [io.path]::GetFileNameWithoutExtension($demoFileName)
Write-Output("File No Extension: $fileNoExtension")


#FIND STEAM & DOTA INSTALL LOCATION
$steamRegistry = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam
#REPLACE THE FOLLOWING LINE WITH THE DIRECTORY ABOVE "steamapps" IF YOUR DOTA 2 INSTALLATION FOLDER IS NOT IN THE DEFAULT LOCATION(IN YOUR STEAM INSTALLATION DIRECTORY)
#$steamInstallPath = $steamRegistry.InstallPath
$steamInstallPath = "F:\SteamLibrary"
$dotaReplayPath = "$steamInstallPath\steamapps\common\dota 2 beta\game\dota\replays\"


#MOVE UNZIPPED FILE
Write-Output("Looking here:  $dotaReplayPath")
if(Test-Path($dotaReplayPath)){
    Move-Item -Path $downloadDirectory\$fileNoExtension -Destination ("$dotaReplayPath\$fileNoExtension")
    Write-Output("File moved")
}
else{
    Write-Output("Dota 2 installation directory not found in default location - please open this script and change the path to the dota 2 replay directory")
    
    #Implement Read-Host here maybe?
}


#WRITE NEW AUTOEXEC TO PLAY DEMO AS SOON AS THE GAME STARTS UP
$cfgPath ="$steamInstallPath\steamapps\common\dota 2 beta\game\dota\cfg"
$autoExec = "$cfgPath\autoexec.cfg"
#CHANGE THE VALUE BELOW IF YOU HAVE ADDITIONAL LAUNCH OPTIONS SET THROUGH YOUR STEAM CLIENT
$playDemo = "playdemo replays/$fileNoExtension"
if (!(Test-Path $autoExec))
{
   New-Item -path $cfgPath -name "autoexec.cfg" -type "file" -value $playDemo
   Write-Host "Created new cfg file and text content added"
}
else
{
  Set-Content -path $autoExec -value $playDemo
  Write-Host "Cfg file already exists - file overwritten"
}


#RUN DOTA
#32-bit or 64 bit for everyone??
$dotaExe = "$steamInstallPath\steamapps\common\dota 2 beta\game\bin\win32\dota2.exe"
#$dotaExe = "$steamInstallPath\steamapps\common\dota 2 beta\game\bin\win64\dota2.exe"
Start-Process -FilePath $dotaExe



#pip install pyauto
# THIS IS A FEW OF THE MANY VARIATIONS I HAD TO ATTEMPT TO GET GIT-BASH TO LAUNCH WITH 
# LEAVING THIS HERE TEMPORARILY FOR POSTERITY 
#bash "D:\\Users\\Skewb\Documents\\repos\\DotaMatchFinder\\unzip.sh"
#bash "/d/Users/Skewb/Documents/repos/DotaMatchFinder/unzip.sh"
# $downloadDirectory\$matchID"
#$gitBash = start "$env:PROGRAMFILES\Git\git-bash.exe"
#"./unzip.bash $downloadDirectory\$matchID" > $gitBash
#Start-Process -FilePath "$env:PROGRAMFILES\Git\git-bash.exe" -Args "./unzip.sh" #$downloadDirectory\$matchID"
#Start-Process -FilePath "$env:PROGRAMFILES\Git\git-bash.exe" -Args "D:\\Users\\Skewb\Documents\\repos\\DotaMatchFinder\\unzip.sh"
#Start-Process -FilePath "$env:PROGRAMFILES\Git\git-bash.exe" -Args "D:\Users\Skewb\Documents\repos\DotaMatchFinder\unzip.sh | sleep 5"
#start "$env:PROGRAMFILES\Git\git-bash.exe" ["./unzip.sh]# $downloadDirectory\$matchID"]
#start "$env:PROGRAMFILES\Git\git-bash.exe" | "./unzip.sh $downloadDirectory\$matchID"
#sh "./unzip.bash $downloadDirectory\$matchID" 
#"$env:PROGRAMFILES\Git\git-bash.exe" > "./unzip.bash $downloadDirectory\$matchID"

Pause


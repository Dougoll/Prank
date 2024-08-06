﻿# Déclaration des variables
$soundLocationRoot = "C:\Temp\"
$soundLocation2 = "C:\Temp\Media\" # endroit ou les fichiers sont déposé sur le PC
$sound1 = "Yamete-kudasai-1.wav" # son connection d'appareils
$sound2 = "Yamete-kudasai-2.wav" # son déconnection d'appareils
$driveLetter = get-volume | where { $_.FileSystemLabel -match "badass_usb" } | select driveletter # lettre de la clé USB

# Création du répertoire C:Temp\Media sur le PC si non existant
$existRoot = Test-Path -Path $soundLocationRoot
$exist2 = Test-Path -Path $soundLocation2
if (!$existRoot -or !$exist2) {
    New-Item -ItemType Directory -Path $soundLocation2 -Force
} 

# Copie des fichiers de son
Copy-Item -Force $PSSCriptRoot"\"$sound1 $soundLocation2
Copy-Item -Force $PSScriptRoot"\"$sound2 $soundLocation2

# Definir le chemin vers le fichiers wav
$wavFilePath1 = "$soundLocation2$sound1"
$wavFilePath2 = "$soundLocation2$sound2"

# Chemins des clés de registre pour configuration du son
$regPath1 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"
$regPath2 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"

# Application des nouvelles valeurs des clés de registre 
Set-ItemProperty -Path $regPath1 -Name "(Default)" -Value $wavFilePath1
Set-ItemProperty -Path $regPath2 -Name "(Default)" -Value $wavFilePath2

# Fermer toutes les fenêtre windows explorer
(New-Object -ComObject Shell.Application).Windows() | %{$_.quit()}

# Désactivation du son
& "C:\temp\nircmd.exe" mutesysvolume 1

# Eject de la clé USB si existante
if ($driveLetter) {
    $drivePath = $driveLetter.driveletter + ":\" # Lettre de la clé USB avec :\
    $driveEject = New-Object -comObject Shell.Application
    $driveEject.Namespace(17).ParseName("$drivePath").InvokeVerb("Eject")
}

# Pause de 5 secondes
Start-Sleep 5

# Activation du son
& "C:\temp\nircmd.exe" mutesysvolume 0

######Par Sébastien Langevin august 2024######
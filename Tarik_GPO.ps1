$VersionURL = "https://raw.githubusercontent.com/wahyuunt97/GPO_Office/refs/heads/main/versi.txt"
$DownloadURL = "https://github.com/wahyuunt97/GPO_Office/raw/refs/heads/main/LDAP_Rule.zip"

$WorkDir = "C:\Windows\Temp\GPO_Kerja"
$LocalVersionFile = "$WorkDir\versi_lokal.txt"
$ZipFile = "$WorkDir\UpdateGPO.zip"

If (!(Test-Path $WorkDir)) { New-Item -ItemType Directory -Force -Path $WorkDir }

try {
    $ServerVersion = Invoke-RestMethod -Uri $VersionURL -UseBasicParsing
    $ServerVersion = $ServerVersion.Trim()
} catch {
    Exit
}

$LocalVersion = "0"
If (Test-Path $LocalVersionFile) { $LocalVersion = Get-Content $LocalVersionFile }

If ($ServerVersion -ne $LocalVersion) {
    Invoke-WebRequest -Uri $DownloadURL -OutFile $ZipFile
    Expand-Archive -Path $ZipFile -DestinationPath $WorkDir -Force
    
    $LGPO_Path = "$WorkDir\LGPO.exe"
    $GPO_Folder = "$WorkDir\Aturan_Kantor"
    & $LGPO_Path /g $GPO_Folder
    
    Set-Content -Path $LocalVersionFile -Value $ServerVersion
    Remove-Item $ZipFile -Force
} Else {
    Exit
}
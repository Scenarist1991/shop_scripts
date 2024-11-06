$min_sie = 1000
$Backup_local =  "C:\1c81\backup1cd\sql\*"
$backups_size = ((Get-ChildItem -Path $Backup_local -Include *.zip -Force -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)[-1])
if
    ($backups_size.Length -gt $min_sie){
    Write-Host -ForegroundColor Green $backup_found "Backup size true"
}
else {
     Write-Host -ForegroundColor Red $backup_found "Backup size false"
    }
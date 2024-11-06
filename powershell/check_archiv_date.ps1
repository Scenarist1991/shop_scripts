$day = Get-Date -Format "yyyy-MM-dd"
$previous_day  = Get-Date ((Get-Date).AddDays(-1)) -Format "yyyy-MM-dd"
$Backup_local =  "C:\1c81\backup1cd\sql\*"
$backups_size = Get-ChildItem -Path $Backup_local -Include *.zip -Force -Recurse -ErrorAction SilentlyContinue
foreach ($backup_size in $backups_size) {
    $date_backups = Get-Date ($backup_size.CreationTime) -Format "yyyy-MM-dd"
if ($date_backups -eq $day) {
    $backups_size_today = $backup_size
    }
elseif ($date_backups -eq $previous_day) {
    $backups_size_previous_day = $backup_size
    }
else {
    Write-Host -ForegroundColor Green $date_backups "day Backup found"
    }
    }     
$sum_backup = 100/ $backups_size_today.Length * $backups_size_previous_day.Length
# Бекап больше или меньше на 20%
if ($sum_backup -ge "120"){
    Write-Host -ForegroundColor Red $Backup "Broken Backup"
    }
elseif ($sum_backup -le "80") {
    Write-Host -ForegroundColor Red $Backup "Broken Backup"
    }
else {
    Write-Host -ForegroundColor Green $Backup "Normal Backup"
    }
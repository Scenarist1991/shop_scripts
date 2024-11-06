$path = "C:\1c81\dbsql\log"
$DATE = Get-Date
$LOG_PATH = "C:\soft\log\log_psql.log"
$pattern = 'invalid page', 'invalid record length'
New-Item $LOG_PATH -Force
write-host $DATE | Out-File $LOG_PATH -Append
Write-Output $DATE | Out-File $LOG_PATH -Append

function search-log {
if ((Test-Path -Path $path) -eq $true) {
    $log_psql = Get-content -Path $path\*.log | Select-String -Pattern $pattern
    foreach ($log_psql1 in $log_psql) {
    Write-Output $log_psql1 | Out-File $LOG_PATH -Append
        }
        }
else {
    Write-Host -ForegroundColor Red $path "PATH not found"
    Write-Output "$path not found" | Out-File $LOG_PATH -Append
        }
} 	
pause
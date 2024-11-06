$DATE = Get-Date
$LOG_PATH = "C:\soft\log\all_run.log"
$PS = "$env:computername"
$Tasks = "Check 1c archive", "pg_backup", "1C_Start", "1C_Stop"
$Services = "Zabbix Agent", "salt-minion", "AstService"
$Backup_PATH = "c:\1c81\backup1cd\sql\*", "\\...\backup1cd\sql\*", "\\...\backup1cd\sql\*"
New-Item $LOG_PATH -Force
write-host $DATE | Out-File $LOG_PATH -Append
function write_log ($param1){
    Out-File -FilePath $Logfile -InputObject $param1 -Append -encoding unicode
    }

function status_license_win () {
    Write-Host "status_license_win:"
    Write-Output "status_license_win:" | Out-File $LOG_PATH -Append
    $lcs = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object -ExpandProperty LicenseStatus
        if ($lcs -eq "1") {
        Write-Host -ForegroundColor Green "windows activated"
        Write-Output -NoEnumerate "windows activated" | Out-File $LOG_PATH -Append
    }
        else {
        Write-Host -ForegroundColor Red "windows not activated"
        Write-Output -NoEnumerate "windows not activated" | Out-File $LOG_PATH -Append
    }
    }
   

function status_task () {
    Write-Host "task:"
    Write-Output "task:" | Out-File $LOG_PATH -Append
    foreach ($taskName in $Tasks)	{
    if (Get-ScheduledTask -TaskPath \ | Where-Object { $_.TaskName -like $taskName }) {             
         Write-Host -ForegroundColor Green $taskName "task found"
         Write-Output -NoEnumerate "$taskName task found" | Out-File $LOG_PATH -Append		
        }
    else {
        Write-Host -ForegroundColor Red $taskName "task not found"
        Write-Output -NoEnumerate "$taskName task not found" | Out-File $LOG_PATH -Append
        }      
    }   
}
function backup_found () {
    Write-Host "backup:"
    Write-Output "backup:" | Out-File $LOG_PATH -Append
    $backup_found = Get-ChildItem -Path C:\1c81\backup1cd\sql -Include *.zip -Force -Recurse -Name  | Out-File $LOG_PATH -Append
    Write-Host -ForegroundColor Green "Backup"
    $backup_found
}

function Network_Adapter () {
    Write-Host "Network_Adapter:"
    Write-Output "Network_Adapter:" | Out-File $LOG_PATH -Append
    Get-NetAdapter | Select-Object MacAddress | Out-File $LOG_PATH -Append
    Get-NetIPAddress | Select-Object IPAddress  | Out-File $LOG_PATH -Append
    Write-Host -ForegroundColor Green "MAC-Adress"
    Write-Host -ForegroundColor Green "IP-Adress"
}

function status_services () {
    Write-Host "services:"
    Write-Output "services:" | Out-File $LOG_PATH -Append
    foreach ($service in $Services) {
    if (Get-Service | Where-Object { $_.Name -like $service }) {
    Write-Host -ForegroundColor Green $service "services found"
    Write-Output -NoEnumerate "$service services found" | Out-File $LOG_PATH -Append
    }
    else {
    Write-Host -ForegroundColor Red $service "services not_found"
    Write-Output -NoEnumerate "$service services not_found " | Out-File $LOG_PATH -Append
    }
}
}

function Backup_PATH1 () {
    Write-Host "Backup_PATH:"
    Write-Output "Backup_PATH:" | Out-File $LOG_PATH -Append
    foreach ($Backup in $Backup_PATH) {
    if ((Test-Path -Include "*.zip" -Path $Backup) -eq $true){
       Write-Host -ForegroundColor Green $Backup "Backup_PATH found"
       Write-Output  -NoEnumerate"$Backup Backup_PATH found" | Out-File $LOG_PATH -Append
        }
    else {
        Write-Host -ForegroundColor Red $Backup "not found Backup_PATH"
        Write-Output -NoEnumerate "$Backup Backup_PATH not found" | Out-File $LOG_PATH -Append
        }
}
}

if ($PS -eq '...') {
    status_license_win
    Network_Adapter
    status_task
    backup_found
    status_services
    Backup_PATH1
}

if ($PS -eq '...') {
    status_license_win
    Network_Adapter
    status_task
    backup_found
    status_services
}

if ($PS -notmatch '...') {
    status_license_win
    Network_Adapter
    status_task
    backup_found
    status_services
}
If ((Get-PackageProvider -Name "Nuget")){
    write-host "Nuget installed"}
    else {
        $ErrorActionPreference = "Stop"
        try {
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -Confirm:$false
        } catch {
            Write-Host "Error occurred: $_"
        }
    }

if (-not (Get-Module -Name "Sentry")) {
    Set-PSRepository PSGallery -InstallationPolicy Trusted
    Install-Module -Name Sentry -Scope CurrentUser -Repository PSGallery -Force -Confirm:$False
}


Import-Module Sentry
Start-Sentry 'http://...'

$date = get-date -Format "yyyy-MM-dd"
$result_file = "C:\Program Files\zabbix\plugins\data\result_check_archive.txt"
$7z_process = (get-process 7z* | Measure-Object).Count
$pc_name = $env:computername
$min_sie = 1000
$Backup_local =  "C:\1c81\backup1cd\sql\*"
$previous_day  = Get-Date ((Get-Date).AddDays(-1)) -Format "yyyy-MM-dd"
$out_file = "C:\1c81\backup1cd\sql\log\out.log"
$path = "C:\1c81\backup1cd\sql"

function create_json ($final_result) {
    $result_json = [PSCustomObject]@{
        Date = $date
        result = $final_result
        } | ConvertTo-Json

    $result_json | Out-File $result_file
    }

function check_Path () {
    if ((Test-Path -Path $path) -eq $true) {
        Write-Host -ForegroundColor Green "Path found"
        create_json ("0")
        }
    else {
        Write-Host -ForegroundColor Red $Backup "Path not found"
        create_json ("3")
        exit 0
        }
    }
function check_archive () {   
    if ($7z_process -eq 1){
    exit 0
    } 
    else {
         $file = ((Get-ChildItem $path/* -file | Sort-Object LastWriteTime)[-1]).FullName
        set-location $env:ProgramFiles\7-zip
        .\7z.exe t -p753429 $file
        if ($LASTEXITCODE -eq 0){
            Write-Host -ForegroundColor Green "archive Verified"
            create_json ("0")
            }
        else {
            Write-Host -ForegroundColor Red "archive broken"
            create_json ($file)
            exit 0
            }
        }

    }

function check_archive_date () {
    $backups_size = Get-ChildItem -Path $Backup_local -Include *.zip -Force -Recurse -ErrorAction SilentlyContinue
    foreach ($backup_size in $backups_size) {
        $date_backups = Get-Date ($backup_size.CreationTime) -Format "yyyy-MM-dd"
    if ($date_backups -eq $date) {
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
        create_json ("5")
        exit 0
        }
    elseif ($sum_backup -le "80") {
        Write-Host -ForegroundColor Red $Backup "Broken Backup"
        create_json ("5")
        exit 0
        }
    else {
        Write-Host -ForegroundColor Green $Backup "Normal Backup"
        create_json ("0")
        }
    }

function check_size_archive () {
    $backups_size_max = ((Get-ChildItem -Path $Backup_local -Include *.zip -Force -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)[-1])
    if
    ($backups_size_max.Length -gt $min_sie){
    Write-Host -ForegroundColor Green "Backup size true"
    create_json ("0")
    }
    else {
     Write-Host -ForegroundColor Red "Backup size false"
     create_json ("4")
     exit 0
    }
    }

function check_log_archive () {   
    if (-not (Test-Path -Path "$out_file")) {
        Write-Host "$out_file not found"
    }
    else {
        $lines = Select-String -Path $out_file -Pattern "error:"
        $count = $lines.Count

        if ($count -eq 0) {
            write-host "Normal log Backup"
            create_json ("0")
        }
        else {
            write-host "255"
            create_json ("255")
            exit 0
        }
    }
    }
try
    {
    if ($pc_name -eq 'name') {
        check_Path
        check_size_archive
        check_log_archive
        check_archive
        check_archive_date
    }
    else {
        exit 0
    }
    
}
catch
{
    $_ | Out-Sentry
}
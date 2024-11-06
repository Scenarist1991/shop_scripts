if "%computername%" EQU "..." (
call C:\soft\schedule\pg_backup.bat
"C:\Program Files\PostgreSQL\15.3-1.1C\bin\psql" -d postgresql://postgres:753429@localhost:5432/postgres -c "select * from pg_create_physical_replication_slot('..._slot');"
"C:\Program Files\PostgreSQL\15.3-1.1C\bin\psql" -d postgresql://postgres:753429@localhost:5432/postgres -c "select slot_name, slot_type, active, wal_status from pg_replication_slots;"
replace C:\soft\postgresql_master.conf C:\1c81\dbsql /A
rename "C:\1c81\dbsql\postgresql.conf" postgresql_bak.conf
rename "C:\1c81\dbsql\postgresql_master.conf" postgresql.conf
net stop pgsql-15.3-1.1C-x64 && net start pgsql-15.3-1.1C-x64
) else ( if "%computername%" EQU "..."
REM replace \\...\Общая\postgresql_replika.conf C:\1c81\dbsql /A
net stop pgsql-15.3-1.1C-x6
IF EXIST C:\1c81\dbsql (rename C:\1c81\dbsql "dbsql_old"
) else (
Not EXIST echo dbsql missing
)
"C:\Program Files\PostgreSQL\15.3-1.1C\bin\pg_basebackup" -h 192.168.0.2 -U postgres -p 5432 -D C:\1c81\dbsql\  -Fp -Xs -P -R  --write-recovery-conf --progress
REM rename "C:\1c81\dbsql\postgresql.conf" postgresql_master.conf
REM rename "C:\1c81\dbsql\postgresql_replika.conf" postgresql.conf
net start pgsql-15.3-1.1C-x64
)
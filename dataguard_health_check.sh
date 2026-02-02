#!/bin/bash
###############################################################################
# Script Name : dataguard_health_check.sh
# Purpose     : Oracle Data Guard Health Check
# Description :
#   - Checks Data Guard role
#   - Displays transport & apply lag
#   - Identifies archive gaps
#
# Prerequisites:
#   - Oracle 19c
#   - Data Guard configured
#   - SYSDBA access
###############################################################################

LOG_DIR="/var/log/oracle_monitor"
DATE=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="$LOG_DIR/dg_health_$DATE.log"

if [[ -z "$ORACLE_HOME" || -z "$ORACLE_SID" ]]; then
  echo "ERROR: ORACLE_HOME or ORACLE_SID not set"
  exit 1
fi

mkdir -p "$LOG_DIR"

echo "Data Guard Health Check started at $(date)" > "$LOG_FILE"

$ORACLE_HOME/bin/sqlplus -s / as sysdba <<EOF >> "$LOG_FILE"
SET LINES 200 PAGES 200 FEEDBACK OFF

PROMPT ===============================
PROMPT DATABASE ROLE & OPEN MODE
PROMPT ===============================

SELECT name, database_role, open_mode FROM v\\$database;

PROMPT ===============================
PROMPT DATAGUARD STATS (LAG)
PROMPT ===============================

SELECT name, value, unit
FROM v\\$dataguard_stats
WHERE name IN ('transport lag','apply lag');

PROMPT ===============================
PROMPT ARCHIVE DEST STATUS
PROMPT ===============================

SELECT dest_id, status, error
FROM v\\$archive_dest_status
WHERE status <> 'VALID';

PROMPT ===============================
PROMPT ARCHIVE GAP CHECK
PROMPT ===============================

SELECT * FROM v\\$archive_gap;

EXIT;
EOF

echo "Data Guard Health Check completed at $(date)" >> "$LOG_FILE"

exit 0

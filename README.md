# Data Guard Health Check Script

Oracle Data Guard monitoring script for checking replication health, lag, and archive gaps.

## Features
- Displays database role
- Shows transport and apply lag
- Detects archive destination errors
- Checks archive gaps

## Prerequisites
- Oracle Database 19c
- Data Guard (Physical Standby)
- SQL*Plus
- SYSDBA privileges

## Setup
```bash
chmod +x dataguard_health_check.sh

#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMMAND=$1

case $COMMAND in
  create-dump)
    BACKUP_FILE=/docker-entrypoint-initdb.d/`date +%Y-%m-%d-%H:%M:%S-%Z`-backup.sql
    echo -e "${GREEN}Creating dump into:${NC} ${BACKUP_FILE}"
    mysqldump -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > $BACKUP_FILE 2>&1 | grep -v "Using a password on the command line interface can be insecure."
    ;;
  mysql-run)
    echo -e "${GREEN}Running into MySQL the command:${NC} $2"
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "$2" $MYSQL_DATABASE 2>&1 | grep -v "Using a password on the command line interface can be insecure."
    ;;
esac

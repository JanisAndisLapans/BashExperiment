#!/bin/bash

mysqldump --add-drop-table --extended-insert --force --log-error=error.log -u"TEST_USER" -p"TEST" TEST_DB | ssh -C "root@$1" "mysql -uTEST_USER -pTEST TEST_DB"

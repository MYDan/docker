#!/bin/bash
/usr/bin/mysql_install_db  --basedir=/usr --datadir=/var/lib/mysql  --user=mysql
nohup /bin/sh /usr/bin/mysqld_safe --datadir=/var/lib/mysql >log 2>&1 &
if [ ! -f /home/work/mydan/etc/agent/auth/mydan.key ];then
    rm -f /home/work/mydan/etc/agent/auth/{mydan.key,mydan.pub,mydan}
    ssh-keygen  -t rsa -P "" -f /home/work/mydan/etc/agent/auth/mydan
    mv /home/work/mydan/etc/agent/auth/mydan /home/work/mydan/etc/agent/auth/mydan.key
fi
/home/work/mydan/dan/tools/release --release v1.0
echo 127.0.0.1 sso.mydan.org >> /etc/hosts
tail -F /home/work/mydan/var/logs/bootstrap/current  /home/work/mydan/sso/logs/deployment.log  /home/work/mydan/dashboard/logs/deployment.log &
mysql < /home/work/mydan/sso/scripts/mysql/db_schema/sso-db-schema.sql
/home/work/mydan/dan/bootstrap/bin/bootstrap  --run

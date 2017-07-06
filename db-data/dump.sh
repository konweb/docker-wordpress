#!/bin/sh

# 環境変数の読み込み
. ../.env


# 引数設定
#  $1 = ローカルドメイン
#  $2 = 本番ドメイン
DOMAIN_LOCAL=${1:-${APP_LOCAL_DOMAIN}:${APP_PORT}}
DOMAIN_PROD=${2:-${APP_PROD_DOMAIN}}

DUMP_PATH=./dump-local-$(date +%Y%m%d%H%M).sql
DUMP_REPLACE_PATH=./dump-local-to-prod-$(date +%Y%m%d%H%M).sql

# ==============================
# Database Dump
# ==============================
echo "-----------------------------------\n"
echo "\033[37m=> \033[m\033[34mRun Database Dump...\033[m"

# docker mysqldump
# db-data/ に mysql.dump.sql が生成される
# 
# テーブルを除外したい場合は、以下のオプションを -p の一行下に挿入
# --ignore-table=$WORDPRESS_DB_NAME.wp_users \
# --ignore-table=$WORDPRESS_DB_NAME.wp_usermeta \

DUMP=`docker exec -it $MYSQL_CONTAINER_NAME sh -c 'MYSQL_PWD=$MYSQL_PASSWORD mysqldump $MYSQL_DATABASE -u $MYSQL_USER --force --compress 2> /dev/null' > $DUMP_PATH`
ret=$?

if [ $ret -eq 0 ] ;then
	echo "\n\033[37m=> \033[m\033[32mDatabase Dump Complate!\033[m"
else
	echo "\n\033[37m=> \033[m\033[31mFatal Error \033[m"
	echo "    $DUMP"
	exit;
fi
echo "\n-----------------------------------"


# ==============================
# Replace Domain name
# ==============================
echo "-----------------------------------\n"
echo "\033[37m=> \033[m\033[34mRun Replace domain of sql file...\033[m"
echo "    local domain = $DOMAIN_LOCAL"
echo "    production domain = $DOMAIN_PROD"

REPLACE=`sed -e "s|${DOMAIN_LOCAL}|${DOMAIN_PROD}|g" $DUMP_PATH 2>&1 >/dev/null > $DUMP_REPLACE_PATH`
ret=$?

if [ $ret -eq 0 ] ;then
	echo "\n\033[37m=> \033[m\033[32mReplace Complate!\033[m"
	echo "    replace > $DUMP_REPLACE_PATH"
else
	echo "\n\033[37m=> \033[m\033[31mFatal Error\033[m"
	echo "    $REPLACE"
	exit;
fi
echo "\n-----------------------------------"

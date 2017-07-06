#!/bin/sh

# 環境変数の読み込み
. ../.env


# 引数設定
IMPORT_PATH=${1:-./dump.sql}
DOMAIN_LOCAL=${2:-${APP_LOCAL_DOMAIN}:${APP_PORT}}
DOMAIN_PROD=${3:-${APP_PROD_DOMAIN}}


# ==============================
# Replace Domain name
# ==============================
echo "-----------------------------------\n"
echo "\033[37m=> \033[m\033[34mRun Replace domain of sql file...\033[m"
echo "    local domain = $DOMAIN_LOCAL"
echo "    production domain = $DOMAIN_PROD"

REPLACE=`sed -i'.bk' -e "s|${DOMAIN_PROD}|${DOMAIN_LOCAL}|g" $IMPORT_PATH 2>&1 >/dev/null`
ret=$?

if [ $ret -eq 0 ] ;then
	echo "\n\033[37m=> \033[m\033[32mReplace Complate!\033[m"
	echo "    replace > $IMPORT_PATH"
else
	echo "\n\033[37m=> \033[m\033[31mFatal Error\033[m"
	echo "    $REPLACE"
	exit;
fi
echo "\n-----------------------------------"


# ==============================
# Database Import
# ==============================
echo "-----------------------------------\n"
echo "\033[37m=> \033[m\033[34mRun Database Import\033[m"

# docker mysql import
docker exec -i $MYSQL_CONTAINER_NAME sh -c 'MYSQL_PWD=$MYSQL_PASSWORD mysql -u $MYSQL_USER $MYSQL_DATABASE' < $IMPORT_PATH
ret=$?

if [ $ret -eq 0 ] ;then
	echo "\n\033[37m=> \033[m\033[32mDatabase Import Complate!\033[m"
else
	echo "\n\033[37m=> \033[m\033[31mFatal Error $ret\033[m"
fi
echo "\n-----------------------------------"

#!/usr/bin/env sh

# run tests against all supported databases using tox
# postgres / mysql run via docker
# sqlite (default) runs against local database file (database.db)
# use pyenv or similar to install multiple python instances

export DJANGO_SETTINGS_MODULE=settings

export IMPORT_EXPORT_POSTGRESQL_USER=pguser
export IMPORT_EXPORT_POSTGRESQL_PASSWORD=pguserpass

export IMPORT_EXPORT_MYSQL_USER=mysqluser
export IMPORT_EXPORT_MYSQL_PASSWORD=mysqluserpass

echo "starting local database instances"
docker compose -f tests/docker-compose.yml up -d

echo "waiting for db initialization"
sleep 45

echo "running tests (sqlite) in parallel"
tox --parallel auto

echo "running tests (mysql) in parallel"
export IMPORT_EXPORT_TEST_TYPE=mysql-innodb
tox --parallel auto

echo "running tests (postgres) in parallel"
export IMPORT_EXPORT_TEST_TYPE=postgres
tox --parallel auto

echo "removing local database instances"
docker compose -f tests/docker-compose.yml down -v

#!/bin/bash
set -e

DB_USER=calendar_user
DB_PASSWORD=calendar_password
DB_NAME=calendar_db
DB_SCHEMA=calendar_schema

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
  CREATE ROLE audit;
  GRANT audit TO $DB_USER;
  CREATE DATABASE $DB_NAME;
  GRANT CREATE ON DATABASE $DB_NAME TO $DB_USER;
  GRANT CREATE ON DATABASE $DB_NAME TO audit;
EOSQL

PGPASSWORD=$DB_PASSWORD psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" <<-EOSQL
  CREATE SCHEMA $DB_SCHEMA;
  GRANT ALL PRIVILEGES ON SCHEMA $DB_SCHEMA TO $DB_USER;
EOSQL
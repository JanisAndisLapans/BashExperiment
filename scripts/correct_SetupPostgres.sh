#!/bin/bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y postgresql
sed -i 's/^port = 5432/port = 5433/' /etc/postgresql/*/main/postgresql.conf
systemctl restart postgresql
su -c "psql -c \"CREATE DATABASE storedb\"" -l postgres
sleep 3
su -c "psql -c \"CREATE ROLE public_view with LOGIN PASSWORD 'fox'\"" -l postgres
su -c "psql -d storedb -f init.sql" postgres
su -c "psql -d storedb -c \"GRANT USAGE ON SCHEMA common_data TO public_view; GRANT SELECT ON ALL TABLES IN SCHEMA common_data TO public_view; ALTER DEFAULT PRIVILEGES IN SCHEMA common_data GRANT SELECT ON TABLES TO public_view;\"" -l postgres

#!/bin/bash

pg_ctlcluster 16 main stop
apt-get install -y postgresql-17
pg_upgradecluster -v 17 16 main /var/lib/postgresql/17/main
pg_dropcluster 16 main
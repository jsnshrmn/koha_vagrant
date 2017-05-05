#!/usr/bin/env bash

mysql -h localhost -u kohaadmin -pkohaadmin koha < /vagrant/kohadump.sql

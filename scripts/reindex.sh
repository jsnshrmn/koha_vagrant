#!/usr/bin/env bash

sudo -u koha bash -c "\
export KOHA_CONF=/etc/koha/koha-conf.xml
export PERL5LIB=/usr/share/koha/lib
/usr/share/koha/bin/migration_tools/rebuild_zebra.pl -b -r -v"

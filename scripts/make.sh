#!/usr/bin/env bash

bash -c "\
export KOHA_CONF=/etc/koha/koha-conf.xml
export PERL5LIB=/usr/share/koha/lib
cd /home/vagrant/koha-3.22.20
make && make test"

sudo bash -c "\
export KOHA_CONF=/etc/koha/koha-conf.xml
export PERL5LIB=/usr/share/koha/lib
cd /home/vagrant/koha-3.22.20
make upgrade"

#!/bin/bash

echo 'POSTGRES: Install Started'


echo 'POSTGRES: Updated yum'
yum update -y

echo 'POSTGRES: add postgres yum repo'
rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm

echo 'POSTGRES: installed postgres database'
sudo yum install -y postgresql11-server

echo 'POSTGRES: initialize database'
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb

echo 'POSTGRES: Start and enable the PostgreSQL 11 and check status'
sudo systemctl start postgresql-11.service
sudo systemctl enable postgresql-11.service
sudo systemctl status postgresql-11.service


echo 'POSTGRES: Install Complete'
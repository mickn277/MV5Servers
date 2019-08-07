#!/bin/bash

echo 'POSTGRES: Install Started'

# 
sudo yum install -y postgresql11-server
echo 'POSTGRES: database installed'

# Initialize the database
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
echo 'POSTGRES: database initialized'

# Start and enable the PostgreSQL 11 and check its status
sudo systemctl start postgresql-11.service
sudo systemctl enable postgresql-11.service
sudo systemctl status postgresql-11.service
echo 'POSTGRES: Start and enable the PostgreSQL 11 and check its status'

echo 'POSTGRES: Install Complete'
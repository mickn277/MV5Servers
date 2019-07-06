#!/bin/bash

echo 'MW CUSTOM Start custom installs and config'


#MW: Fix timezone 
timedatectl set-timezone Australia/Brisbane
echo 'MW CUSTOM: Timezone updated'

#MW: Install utilities
yum install -y glances iftop
echo 'MW CUSTOM: Install glances iftop'


echo 'MW CUSTOM: Complete custom Installs'

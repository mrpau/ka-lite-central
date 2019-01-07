#!/usr/bin/env bash

# REF: https://tech.osteel.me/posts/2015/01/25/how-to-use-vagrant-for-local-web-development.html
# REF: https://imdibosh.wordpress.com/2016/08/06/vagrant-uwsgi-and-nginx-serve-a-django-app-locally/

curl -sL https://deb.nodesource.com/setup_0.12 | bash -
echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
apt-get -y update
apt-get install -yqq nodejs mysql-server-5.5 git-core python-mysqldb python python-pip python-virtualenv python-dev libmysqlclient-dev
apt-get -y install nginx
apt-get -y install tree
apt-get upgrade -y
easy_install -U pip

# ==========
# Setup mysql user. Highly insecure.
mysql -uroot -proot -e "CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'pass';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON * . * TO 'dbuser'@'localhost'; FLUSH PRIVILEGES;"
mysql -udbuser -ppass -e "CREATE DATABASE kalite_central_server;"


VAGRANT_DIR="/vagrant"

# Go to the source directory.
cd $VAGRANT_DIR

npm install
npm install -g grunt-cli



#!/bin/sh
curl -sL https://deb.nodesource.com/setup_0.12 | bash -
echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
apt-get update
apt-get install -yqq nodejs mysql-server-5.5 git-core python-mysqldb python python-pip python-virtualenv python-dev libmysqlclient-dev
apt-get upgrade -y
easy_install -U pip

# Set up mysql user. Highly insecure.
mysql -uroot -proot -e "CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'pass';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON * . * TO 'dbuser'@'localhost'; FLUSH PRIVILEGES;"
mysql -udbuser -ppass -e "CREATE DATABASE kalite_central_server;"

VAGRANT_DIR="/vagrant"

# Go to the source directory.
cd $VAGRANT_DIR

npm install
npm install -g grunt-cli

# create a `local_settings.py` file with default values
echo >> centralserver/local_settings.py
echo "DEBUG=True" >> centralserver/local_settings.py

# TODO(cpauya): pip install virtualenvwrapper


## Django-specific commands
CENTRALSERVER_DIR="$VAGRANT_DIR/centralserver"

# Go to the source directory.
cd $VAGRANT_DIR

# TODO(cpauya): pip install virtualenvwrapper

# MUST: Create and use a virtualenv coz if we don't, we get errors during pip install because some packages 
# were installed using disutils.
ENV_NAME="virtualenv"
ENV_DIR="$VAGRANT_DIR/$ENV_NAME"
ENV="$ENV_DIR/bin/activate"

echo "ENV_DIR == $ENV_DIR; ENV==$ENV"
cd "$ENV_DIR"
# MUST: We use this format instead of `source $ENV` so we run the next commands in the same shell NOT in a sub-shell,
# else, the variables declared under this shell will NOT be available in the sub-shell so the `pip install` command 
# below will not succeed.
# REF: https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it#176788
. $ENV
cd $CENTRALSERVER_DIR

pip install -r $VAGRANT_DIR/requirements.txt

## TODO(cpauya): Use Nginx/Apache2 to load the app.
./manage.py runserver 0.0.0.0:8000

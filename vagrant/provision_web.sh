#!/usr/bin/env bash

# REF: https://tech.osteel.me/posts/2015/01/25/how-to-use-vagrant-for-local-web-development.html
# REF: https://imdibosh.wordpress.com/2016/08/06/vagrant-uwsgi-and-nginx-serve-a-django-app-locally/
# REF: https://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html

VAGRANT_DIR="/vagrant"


# ==========
# Setup uWSGI

pip install uwsgi

UWSGI_DIR="$VAGRANT_DIR/vagrant/uwsgi"
UWSGI_SITES_DIR="/etc/uwsgi/sites"
UWSGI_LOGS_DIR="/etc/uwsgi/logs"
UWSGI_VASSALS_DIR="/etc/uwsgi/vassals"

mkdir -p $UWSGI_SITES_DIR
mkdir -p $UWSGI_LOGS_DIR
mkdir -p $UWSGI_VASSALS_DIR

sudo ln -s -f $UWSGI_DIR/central_uwsgi.ini $UWSGI_VASSALS_DIR

cp $UWSGI_DIR/uwsgi.conf /etc/init/centralserver.conf

# sudo uwsgi --emperor /etc/uwsgi/vassals --uid www-data --gid www-data
# uwsgi --emperor /etc/uwsgi/vassals
# uwsgi --emperor /etc/uwsgi/vassals --uid www-data --gid www-data --daemonize /var/log/uwsgi-emperor.log

# DELETEME(cpauya): no need for this already coz the nginx.conf already points to the uWSGI implem
# ln -s -f $UWSGI_DIR/central_nginx.conf /etc/nginx/sites-enabled


# ==========
# Setup Django web app

# Go to the source directory.
cd $VAGRANT_DIR

# If it doesn't exist, create a `local_settings.py` file with default values.
LOCAL_SETTINGS_FILE="centralserver/local_settings.py"
if [ ! -f $LOCAL_SETTINGS_FILE ]; then
    echo >> centralserver/local_settings.py
    echo "DEBUG=True" >> centralserver/local_settings.py
fi

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

cd "$ENV_DIR"
# MUST: We use this format instead of `source $ENV` so we run the next commands in the same shell NOT in a sub-shell,
# else, the variables declared under this shell will NOT be available in the sub-shell so the `pip install` command 
# below will not succeed.
# REF: https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it#176788
. $ENV
cd $CENTRALSERVER_DIR

pip install -r $VAGRANT_DIR/requirements.txt

# TODO(cpauya): Do we need this?
# ./manage.py collectstatic --noinput


# ==========
# Setup Nginx server

NGINX_DIR="$VAGRANT_DIR/vagrant/nginx"

service nginx stop

# Remove the default Nginx config file.
rm -f /etc/nginx/sites-enabled/default

ln -s -f $NGINX_DIR/nginx.conf /etc/nginx/sites-available/
ln -s -f $NGINX_DIR/nginx.conf /etc/nginx/sites-enabled/

# clean /var/www
rm -Rf /var/www

# symlink /var/www => /vagrant
ln -s $VAGRANT_DIR /var/www

# Add vagrant user to Nginx's www-data group
# NOTE(cpauya): may NOT be needed, but this is to read the /tmp/central.sock file of uwsgi.
usermod -a -G www-data vagrant

service nginx restart

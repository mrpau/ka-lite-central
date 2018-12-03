#!/bin/sh

VAGRANT_DIR="/vagrant"
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
# source $ENV
# MUST: We use this format instead of `source $ENV` so we run the next commands in the same shell NOT in a sub-shell.
. $ENV
cd $CENTRALSERVER_DIR

pip install -r $VAGRANT_DIR/requirements.txt

# cd $VAGRANT_DIR/centralserver

# # TODO(cpauya): use nginx/apache instead of the Django web server
# ./manage.py runserver 0.0.0.0:8000

# KA Lite Central Server

This is the code for the KA Lite Central server.  Here's the code for KA Lite: [https://kalite.learningequality.org](https://kalite.learningequality.org)


## What this is
  
A Django app which is "It's Complicated" with [ka-lite](https://github.com/learningequality/ka-lite.git).  Distributed KA Lite servers are configured to point to an instance of the Central server, which manages their syncing.  Could be managing many different versions of KA Lite at once.


## General Requirements

1. git
1. A running [KA-Lite](https://github.com/learningequality/ka-lite) server on local machine.
1. [Docker](https://www.docker.com/get-started) or [Vagrant](https://www.vagrantup.com)


## Checkout the sources

1. Get the KA Lite Central codebase: `git clone --recursive https://github.com/fle-internal/ka-lite-central.git`.
    * If you're planning to make changes, you should fork the repo and clone your fork instead.
2. Run `git submodule update` in the directory created by the last command.


## TODO(cpauya): Environment setup using Docker

1. Run `docker build image .` to build the Docker image for devt.


## Environment setup using Vagrant

TODO(cpauya): The Vagrant box should be similar to the production server setup.

Hopefully we can standardize our dev environment and get up and running much more quickerer.

1. Get the latest version of vagrant. **Warning:** On Debian (even on testing) the version is far behind. Get it from the [Vagrant](https://www.vagrantup.com) website.
2. Run `vagrant up` to start the machine and provision it.
    * This will take a long time.
    * The `ka-lite-central` directory of your host computer is automatically shared as a directory in the `/vagrant/` folder of the Vagrant box.
3. If the provisioning script was successful, you can open `http://localhost:8030/` in your host machine web browser to open the KA-Lite central Django server.
4. These next steps are optional.  
    * To further customize the Vagrant box, run `vagrant ssh` to start an SSH session in the virtual machine. Go to the `/vagrant/centralserver` directory and run the command `./manage.py setup` and follow the prompts to finish the setup process.
    * Run `./manage runserver 0.0.0.0:8030` to load the KA-Lite Django server.


### Vagrant box specs
    1. Ubuntu 14.04 LTS 32-bit
    1. Python 2.7.x
    1. MySQL 5.5
    1. Django 1.5.12
        1. This is based on the version at `ka-lite-submodule/python-packages/django/__init__.py`.
        1. TODO(cpauya): Since multiple KA Lite servers sync to the Central server, it is assumed that they will have different versions.  This Central server Django version must therefore be >= the most recent Django version of all distributed KA Lite servers.
    1. A `virtualenv` is located under the `/vagrant/virtualenv` folder so you can activate a virtual environment inside the Vagrant box by running `source /vagrant/virtualenv/bin/activate`.


<!-- 
### Environment setup using Virtualenv:

If you have no idea how to use Virtualenv, here's a primer as one reference [How to use Python Virtualenv](https://www.pythonforbeginners.com/basics/how-to-use-python-virtualenv).  The rest of the document assumes you already know how to use Virtualenv.

1. [install node](http://nodejs.org/download/) if you don't have it already.
2. install the requirements from ka-lite-submodule's `requirements.txt`
3. install requirements from `requirements.txt`
4. Get the codebase: `git clone --recursive https://github.com/fle-internal/ka-lite-central.git` (if you're planning to make changes, you should fork the repo and clone your fork instead)
5. Install the dependencies listed in `packages.json` with `sudo npm install`
    1. Also install them in the ka-lite-submodule: `cd ka-lite-submodule` and `npm install`
6. Install grunt: `sudo npm install -g grunt-cli`
7. Go into the centralserver directory: `cd centralserver`
8. Set up the server: `python manage.py setup --no-assessment-items`
6. Return to the root directory: 'cd ..'
7. Run grunt in the root directory: `grunt`
8. Run `node build.js` in the ka-lite-submodule to build js assets.
9. Return to the code directory: `cd centralserver`
10. Set up a custom `centralserver/local_settings.py` file (see below)
11. Run the server: `python manage.py runserver 0.0.0.0:8000`
 -->


## Running ka-lite-central

### Pointing ka-lite server/s to local Central server

After cloning the KA Lite server codebase from https://github.com/learningequality/ka-lite, add the following to its `kalite/local_settings.py` prior to running `install.sh` or `install.bat`:
```
CENTRAL_SERVER_HOST   = "127.0.0.1:8000"
SECURESYNC_PROTOCOL   = "http"
```

This will cause it to point to your locally running instance of the central server for registering and syncing.

### Setup of `local_settings.py`

You may create a `centralserver/local_settings.py` file to customize your setup.  Here are a few options to consider:

#### For debugging

* `DEBUG = True` - turns on debug messages
* `EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"` - will output email messages (like account registration and contact) to the console
* `USE_DEBUG_TOOLBAR = True` - Use the Django debug toolbar, which gives info about queries, context values, and more!

#### For building language packs
* `CROWDIN_PROJECT_ID` and `CROWDIN_PROJECT_KEY` - these are private; you'll have to get in touch with a (Learning Equality) team member who has them.
* * `KA_CROWDIN_PROJECT_ID` and `KA_CROWDIN_PROJECT_KEY` - these are private (from Khan Academy); you'll have to get in touch with a (Learning Equality) team member who has them.

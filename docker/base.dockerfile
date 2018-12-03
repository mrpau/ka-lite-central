FROM ubuntu:trusty

# TODO(cpauya): We must install the libraries with similar versions to the production server.
# install latest python and nodejs
RUN apt-get -y update && \
  apt-get install -y software-properties-common curl && \
  curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get -y update && apt-get install -y python2.7 python-pip git nodejs gettext wget

COPY . /ka-lite-central

WORKDIR /ka-lite-central
# VOLUME /ka-lite-central/

# Use virtualenv's pip
#ENV PIP=/venv/ka-lite-central_env/bin/pip

# use virtualenv
#RUN pip install setuptools pip --upgrade --force-reinstall
#RUN pip install virtualenv && virtualenv /venv/ka-lite-central_env  --python=python2.7

#RUN $PIP install -r "/ka-lite-central/requirements.txt"

# RUN pip install -r "/ka-lite-central/requirements.txt"

# Override the PATH to add the path of our virtualenv python binaries first so it's python executes instead of
# the system python.
# ENV PATH=/ka-lite-central/:/ka-lite-central/ka-lite-submodule:/ka-lite-central/ka-lite-submodule/python-packages:$PATH

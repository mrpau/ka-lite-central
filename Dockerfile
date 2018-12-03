FROM python:2.7

RUN mkdir /code
ADD . /code/
WORKDIR /code

RUN pip install mysql-python
RUN pip install django==1.5.12
RUN pip install -r /code/requirements.txt
# RUN pip install -e /code/ka-lite-submodule/kalite

# RUN pip install -e /code/ka-lite-submodule/kalite
# RUN pip install -e /code/ka-lite-submodule/python-packages

# Override the PATH to add the path of our virtualenv python binaries first so it's python executes instead of
# the system python.
# RUN export PYTHONPATH="/code/:/code/ka-lite-submodule:/code/ka-lite-submodule/kalite/:/code/ka-lite-submodule/python-packages:${PYTHONPATH}"

# ENV PATH=/code/:/code/ka-lite-submodule:/code/ka-lite-submodule/kalite/:/code/ka-lite-submodule/python-packages:$PATH

# RUN env | grep PATH
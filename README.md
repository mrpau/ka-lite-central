# KA Lite Central Server

This is the code for the KA Lite Central Server: [https://kalite.learningequality.org](https://kalite.learningequality.org)

## Environment Setup 

1. Install requirements: 
    - [install pip](https://pypi.python.org/pypi/pip) if you don't have it already. 
    - [install node](http://nodejs.org/download/) if you don't have it already.

2. Get the codebase: `git clone git@github.com:fle-internal/ka-lite-central.git`

3. Install the dependencies listed in requirements.txt: `pip install -r requirements.txt`
 
4. Install the dependencies listed in packages.json: `sudo npm install`

5. Install grunt: `sudo npm install -g grunt-cli`

6. Run grunt in the root directory: `grunt`

7. Download Geo IP data: `curl http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip > data/geo/GeoLiteCity.dat`

8. Download Country List Data: `curl http://www.textfixer.com/resources/dropdowns/country-list-iso-codes.txt > data/geo/country-list-iso-codes.txt`

9. Go into the code directory: `cd code`

10. Set up the database: `python manage.py syncdb --migrate`

11. Run the server: `python manage.py runserver`

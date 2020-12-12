FROM python:3.8

# To not deploy the Flask Monitoring Dashboard comment the following two lines (and the corresponding section below)
ARG API_VERSION
RUN test -n "$API_VERSION" || (echo "API_VERSION not set use --build-arg... " && false)

# Install apache2
RUN apt-get update
RUN apt-get install -y \
    apache2 \
    apache2-dev \
    vim

# Install an up to date wsgi
RUN pip install mod_wsgi
RUN /bin/bash -c 'mod_wsgi-express install-module | tee /etc/apache2/mods-available/wsgi.{load,conf}'
RUN a2enmod wsgi
RUN a2enmod headers

COPY --chown=www-data:www-data Python-Wordstats /opt/Python-Wordstats
WORKDIR /opt/Python-Wordstats
RUN python setup.py develop

# Install Zeeguu-Core
COPY --chown=www-data:www-data Zeeguu-Core /opt/Zeeguu-Core
WORKDIR /opt/Zeeguu-Core
RUN pip install -r requirements.txt

#for i don't know what reason, if we 'install' it here, we can't uninstall it later!
# thus we 'develop'
RUN python setup.py develop


#ML: This is needed because the translators installer installs nltk in ~ (which in the
# case of docker is /root. however, when run, it runs as www-data with ~ being /var/www 
RUN python -m nltk.downloader -d /var/www/nltk_data punkt
RUN python -m nltk.downloader -d /var/www/nltk_data averaged_perceptron_tagger


# Install Zeeguu-API
# ==================
# Apache will run Zeeguu-API as a WSGI module. It needs to create the DB for wordsstats:
# https://github.com/zeeguu-ecosystem/Python-Wordstats/blob/master/wordstats/config.py#L1
# under /opt/Zeeguu-API/wordinfo.db
COPY --chown=www-data:www-data Zeeguu-API /opt/Zeeguu-API
WORKDIR /opt/Zeeguu-API
RUN pip install -r requirements.txt
RUN python setup.py install

## Installing Flask Monitoring Dashboard (FMD)
## ===========================================
## comment the lines in this section if you do not want the FMD deployed

#.1 Alternative one: from PyPI
#RUN pip install flask_monitoringdashboard

#.2 Alternative two: install from sources
COPY Flask-MonitoringDashboard /opt/Flask-MonitoringDashboard
WORKDIR /opt/Flask-MonitoringDashboard
RUN python setup.py install 

## NOTE(mircealungu) previous pip install is here because fmd still can't be added to the 
##     requiremens... a bug prevents the API tests from running when the FMD is deployed
##     TODO: make sure to move the flask_monitoring_dashboard to requirements and remove
##     this line once the tests problem is fixed

COPY --chown=www-data:www-data config/fmd.cfg /opt/zeeguu/config/fmd.cfg
ENV FLASK_MONITORING_DASHBOARD_CONFIG=/opt/zeeguu/config/fmd.cfg
RUN sed -i "s,APP_VERSION.*,APP_VERSION=$API_VERSION,g" /opt/zeeguu/config/fmd.cfg 

# NOTE(mircealungu): ensure to only have the APP_VERSION since otherwise the GIT config supersedes it
RUN sed -i "s,GIT.*,,g" /opt/zeeguu/config/fmd.cfg 

# END of FMD related code


# Set default path to config
COPY --chown=www-data:www-data config/core.cfg /opt/zeeguu/config/core.cfg
ENV ZEEGUU_CORE_CONFIG=/opt/zeeguu/config/core.cfg

COPY --chown=www-data:www-data config/api.cfg /opt/zeeguu/config/api.cfg
ENV ZEEGUU_API_CONFIG=/opt/zeeguu/config/api.cfg



# Enable Zeeguu-Web website
COPY ./docker-files/zeeguu-api-core/apache-zeeguu-api.conf /etc/apache2/sites-available/apache-zeeguu-api.conf
# Disable default website and enable zeeguu
RUN a2dissite 000-default.conf
RUN a2ensite apache-zeeguu-api

# Apache will listen on port 8080 for the API
# Zeeguu-Web will forward requests from /api to this apache
RUN sed -i "s,Listen 80,Listen 8080,g" /etc/apache2/ports.conf

WORKDIR /opt/Zeeguu-API

# Create the zeeguu-data folder
RUN mkdir /opt/zeeguu-data && chown www-data:www-data /opt/zeeguu-data

CMD  /usr/sbin/apache2ctl -D FOREGROUND

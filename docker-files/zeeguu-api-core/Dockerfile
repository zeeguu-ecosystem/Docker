FROM python:3.6

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

# Install Zeeguu-Core
COPY Zeeguu-Core /opt/Zeeguu-Core
WORKDIR /opt/Zeeguu-Core
RUN pip install -r requirements.txt
RUN python setup.py install

# Install Zeeguu-API
# Apache will run Zeeguu-API as a WSGI module. It needs to create the DB for wordsstats:
# https://github.com/zeeguu-ecosystem/Python-Wordstats/blob/master/wordstats/config.py#L1
# under /opt/Zeeguu-API/wordinfo.db
COPY --chown=www-data:www-data Zeeguu-API /opt/Zeeguu-API
RUN rm -rf /opt/Zeeguu-API/.git
COPY --chown=www-data:www-data .git/modules/Zeeguu-API /opt/Zeeguu-API/.git
RUN cp -R /root/ntlk_data /var/www/nltk_data
WORKDIR /opt/Zeeguu-API
RUN pip install -r requirements.txt

# ML: this is here because it still can't be added to the requiremens... a bug prevents
# the API tests from running when the FMD is deployed
RUN pip install flask_monitoringdashboard
RUN python setup.py install

# Set default path to config
ENV ZEEGUU_CORE_CONFIG=/opt/Zeeguu-Core/default_core.cfg
ENV ZEEGUU_API_CONFIG=/opt/Zeeguu-API/default_api.cfg
ENV ZEEGUU_CORE_LOG_DIR=/tmp/zeeguu-core-logs

# set this if you want to use the FMD...
#ENV FLASK_MONITORING_DASHBOARD_CONFIG=/opt/fmd/dashboard.cfg

# TODO: Check if this is still required
# RUN python -m zeeguu.populate

# Enable Zeeguu-Web website
COPY ./docker-files/zeeguu-api-core/apache-zeeguu-api.conf /etc/apache2/sites-available/apache-zeeguu-api.conf
# Disable default website and enable zeeguu
RUN a2dissite 000-default.conf
RUN a2ensite apache-zeeguu-api

# Apache will listen on port 8080 for the API
# Zeeguu-Web will forward requests from /api to this apache
RUN sed -i "s,Listen 80,Listen 8080,g" /etc/apache2/ports.conf

WORKDIR /opt/Zeeguu-API

CMD  /usr/sbin/apache2ctl -D FOREGROUND

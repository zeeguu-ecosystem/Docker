FROM python:3.7

# The public IP where the zeeguu API can be reached on
# It will be used in the static JS
# ZEEGUU_API is accessed from the static JS client code.
ARG ZEEGUU_API=https://api.zeeguu.org

# The IP for the API to be redirected to from the Apache 
# reverse proxy and from the Python backend
# If running on the same machine might be localhost
ARG ZEEGUU_API__INTERNAL=https://api.zeeguu.org


# Install apache2
RUN apt-get update
RUN apt-get install -y \
    apache2 \
    apache2-dev \
    vim \
    nodejs \
    npm \
    certbot python-certbot-apache


# Upgrade npm
RUN npm i npm@latest -g
# running it twice to ensure that the warning of before does not appear anymore
RUN npm i npm@latest -g

# Install an up to date wsgi
RUN pip install mod_wsgi
RUN /bin/bash -c 'mod_wsgi-express install-module | tee /etc/apache2/mods-available/wsgi.{load,conf}'
RUN a2enmod wsgi
RUN a2enmod headers
RUN a2enmod ssl 

# prepare the conf- for letsencrypt
RUN mkdir -p /var/www/html/.well-known/acme-challenge
COPY --chown=www-data:www-data docker-files/zeeguu-web/le.conf /etc/apache2/conf-available/le.conf
run a2enconf le

# All folders exposed via apache need to be owned by www-data since
# that is the user apache will run under.

# Install Zeeguu-Web
COPY --chown=www-data:www-data Zeeguu-Web-2.0 /opt/Zeeguu-Web
WORKDIR /opt/Zeeguu-Web/javascript
RUN npm install
RUN npm install -g webpack webpack-cli
RUN webpack --env.ZEEGUU_API=$ZEEGUU_API --config reader.config.js
RUN webpack --env.ZEEGUU_API=$ZEEGUU_API --config exercises.config.js
WORKDIR /opt/Zeeguu-Web/python
RUN pip install -r requirements.txt
RUN python setup.py develop

# Install Teacher-Dashboard
COPY --chown=www-data:www-data Zeeguu-Teacher-Dashboard /opt/Zeeguu-Teacher-Dashboard
WORKDIR /opt/Zeeguu-Teacher-Dashboard/src
RUN pip install -r requirements.txt
RUN python setup.py install

# Copy over the zeeguu_web/static files under /var/www
RUN cp -r /opt/Zeeguu-Web/python /var/www/zeeguu-web

# Change permissions since apache runs with www-data user
RUN chown www-data /var/www
RUN chgrp www-data /var/www


# Copy the config files
COPY --chown=www-data:www-data config/web.cfg /opt/zeeguu/config/web.cfg
#COPY --chown=www-data:www-data config/teacherdash.cfg /opt/zeeguu/config/teacherdash.cfg

# Teacher Dashboard React
COPY --chown=www-data:www-data Zeeguu-Teacher-Dashboard-React /opt/Zeeguu-Teacher-Dashboard-React
WORKDIR /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard

RUN echo "REACT_APP_ZEEGUU_API_ENDPOINT_PROD=$ZEEGUU_API" > .env
RUN echo "REACT_APP_ROOT_NAME=teacher-dashboard" >> .env
RUN npm install
RUN npm run build
RUN cp -r /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/build /var/www/teacher-dashboard



# mod_wsgi will not be able to import python packages without this
ENV PYTHONPATH=/usr/local/lib/python3.6/site-packages

WORKDIR /opt

# Create the zeeguu-data folder
RUN mkdir /opt/zeeguu-data && chown www-data:www-data /opt/zeeguu-data

# Zeeguu-Web
ENV ZEEGUU_WEB_CONFIG=/opt/zeeguu/config/web.cfg

# Teacher-Dashboard
#ENV TEACHER_DASHBOARD_CONFIG=/opt/zeeguu/config/teacherdash.cfg
#ENV ZEEGUU_API=$ZEEGUU_API

# Enable Zeeguu-Web website
COPY ./docker-files/zeeguu-web/apache-zeeguu.conf /etc/apache2/sites-available/apache-zeeguu.conf

RUN sed -i "s,http://127.0.0.1:8080,$ZEEGUU_API__INTERNAL,g" /etc/apache2/sites-available/apache-zeeguu.conf

# Disable default website and enable zeeguu
RUN a2dissite 000-default.conf
#RUN a2ensite apache-zeeguu.conf

# Copy also the zeeguu-conf-ssl
COPY ./docker-files/zeeguu-web/apache-zeeguu-ssl.conf /etc/apache2/sites-available/apache-zeeguu-ssl.conf
RUN a2ensite apache-zeeguu-ssl.conf

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http

ENV ZEEGUU_API=$ZEEGUU_API__INTERNAL
CMD  /usr/sbin/apache2ctl -D FOREGROUND

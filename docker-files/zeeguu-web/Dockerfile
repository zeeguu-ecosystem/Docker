FROM python:3.7

# Build arguments with default values, overwrite at build-time using
# "--build-arg <varname>=<value>"
ARG DEFAULT_ZEEGUU_API="https://zeeguu.unibe.ch/api"
# The public IP where the zeeguu API can be reached on
# It will be used in the static JS
# ZEEGUU_API__EXTERNAL is accessed from the static JS client code.
ARG ZEEGUU_API__EXTERNAL=http://127.0.0.1:9001
# ZEEGUU_API__INTERNAL is accessed from the python code.
ARG ZEEGUU_API__INTERNAL=http://127.0.0.1:8080

# The ZEEGUU_API__EXTERNAL should be reachable from the client side while
# ZEEGUU_API__INTERNAL has to be reachable from the server side.

# Install apache2
RUN apt-get update
RUN apt-get install -y \
    apache2 \
    apache2-dev \
    vim \
    nodejs \
    npm 

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

# All folders exposed via apache need to be owned by www-data since
# that is the user apache will run under.

# Install Zeeguu-Web
COPY --chown=www-data:www-data Zeeguu-Web /opt/Zeeguu-Web
WORKDIR /opt/Zeeguu-Web
RUN pip install -r requirements-dev.txt
RUN python setup.py install

# Install Teacher-Dashboard
COPY --chown=www-data:www-data Zeeguu-Teacher-Dashboard /opt/Zeeguu-Teacher-Dashboard
WORKDIR /opt/Zeeguu-Teacher-Dashboard/src
RUN pip install -r requirements.txt
RUN python setup.py install

# Install Zeeguu-Exercises
COPY --chown=www-data:www-data Zeeguu-Exercises /opt/Zeeguu-Exercises
WORKDIR /opt/Zeeguu-Exercises
# Update Zeeguu API url
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__EXTERNAL,g" javascript/app/settings.js
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__INTERNAL,g" python/zeeguu_exercises/endpoints.py
# Front-end
RUN npm install
# commented out because it's redundat with the next command!
#RUN ./node_modules/.bin/webpack
RUN npm run build
# Back-end
RUN pip install -r requirements.txt
WORKDIR /opt/Zeeguu-Exercises/python
RUN pip install --upgrade --force-reinstall setuptools
RUN python setup.py develop

# Install Zeeguu Reader
COPY --chown=www-data:www-data Zeeguu-Reader /opt/Zeeguu-Reader
WORKDIR /opt/Zeeguu-Reader
# Update Zeeguu API url
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__EXTERNAL,g" src/umr/static/scripts/app/zeeguuRequests.js
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__INTERNAL,g" src/umr/login.py
# Front-end
RUN npm install
RUN ./node_modules/.bin/webpack
# Back-end
RUN pip install -r requirements.txt
WORKDIR /opt/Zeeguu-Reader/src
RUN python setup.py install

# Copy over the zeeguu_web/static files under /var/www
RUN cp -r /opt/Zeeguu-Web /var/www/zeeguu-web

# Change permissions since apache runs with www-data user
RUN chown www-data /var/www
RUN chgrp www-data /var/www


# Copy the config files
COPY --chown=www-data:www-data config/web.cfg /opt/zeeguu/config/web.cfg
#COPY --chown=www-data:www-data config/teacherdash.cfg /opt/zeeguu/config/teacherdash.cfg

# Teacher Dashboard React
COPY --chown=www-data:www-data Zeeguu-Teacher-Dashboard-React /opt/Zeeguu-Teacher-Dashboard-React
WORKDIR /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard

RUN echo "REACT_APP_ZEEGUU_API_ENDPOINT_PROD=$ZEEGUU_API__EXTERNAL" > .env
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
RUN sed -i "s,http://127.0.0.1:9001,$ZEEGUU_API__INTERNAL/,g" /opt/zeeguu/config/web.cfg

# Disable default website and enable zeeguu
RUN a2dissite 000-default.conf
RUN a2ensite apache-zeeguu.conf


RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http

CMD  /usr/sbin/apache2ctl -D FOREGROUND

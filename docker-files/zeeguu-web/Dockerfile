FROM python:3.6

# Build arguments with default values, overwrite at build-time using
# "--build-arg <varname>=<value>"
ARG DEFAULT_ZEEGUU_API="https://zeeguu.unibe.ch/api"
# The public IP where the zeeguu API can be reached on
# It will be used in the static JS
# ZEEGUU_API__EXTERNAL is accessed from the static JS client code.
ARG ZEEGUU_API__EXTERNAL=http://127.0.0.1:9001
# ZEEGUU_API__INTERNAL is accessed from the python code.
ARG ZEEGUU_API__INTERNAL=http://127.0.0.1:9001

# The ZEEGUU_API__EXTERNAL should be reachable from the client side while
# ZEEGUU_API__INTERNAL has to be reachable from the server side.

# Install apache2
RUN apt-get update
RUN apt-get install -y \
    apache2 \
    apache2-dev \
    vim

# Install npm
WORKDIR /tmp
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# Install an up to date wsgi
RUN pip install mod_wsgi
RUN /bin/bash -c 'mod_wsgi-express install-module | tee /etc/apache2/mods-available/wsgi.{load,conf}'
RUN a2enmod wsgi
RUN a2enmod headers

# Enable Zeeguu-Web website
COPY ./docker-files/zeeguu-web/apache-zeeguu.conf /etc/apache2/sites-available/apache-zeeguu.conf
RUN a2ensite apache-zeeguu

# All folders exposed via apache need to be owned by www-data since
# that is the user apache will run under.

# Install Zeeguu-Web
COPY --chown=www-data:www-data Zeeguu-Web /opt/Zeeguu-Web
WORKDIR /opt/Zeeguu-Web
RUN pip install -r requirements.txt
RUN python setup.py install

# Install Teacher-Dashboard
COPY --chown=www-data:www-data Zeeguu-Teacher-Dashboard /opt/Zeeguu-Teacher-Dashboard
WORKDIR /opt/Zeeguu-Teacher-Dashboard/teacher_dashboard
RUN pip install -r requirements.txt
RUN python setup.py install

# Install Exercises-Platform
COPY --chown=www-data:www-data Zeeguu-Exercises /opt/Zeeguu-Exercises
WORKDIR /opt/Exercises-Platform
# Update Zeeguu API url
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__EXTERNAL,g" src/zeeguu_exercises/static/js/app/settings.js
RUN sed -i "s,$DEFAULT_ZEEGUU_API,$ZEEGUU_API__INTERNAL,g" src/zeeguu_exercises/endpoints.py
# Front-end
RUN npm install
RUN ./node_modules/.bin/webpack
RUN npm run build
# Back-end
RUN pip install -r requirements.txt
WORKDIR /opt/Exercises-Platform/src
RUN python setup.py install

# Install Unified Multilanguage Reader
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
WORKDIR /opt/Unified-Multilanguage-Reader/src
RUN python setup.py install

# Copy over the zeeguu_web/static files under /var/www
RUN cp -r /opt/Zeeguu-Web /var/www/zeeguu-web

# Change permissions since apache runs with www-data user
RUN chown www-data /var/www
RUN chgrp www-data /var/www

# Disable default website and enable zeeguu
RUN a2dissite 000-default.conf
RUN a2ensite apache-zeeguu.conf

# mod_wsgi will not be able to import python packages without this
ENV PYTHONPATH=/usr/local/lib/python3.6/site-packages

WORKDIR /opt

# Zeeguu-Core
ENV ZEEGUU_CORE_LOG_DIR=/tmp/zeeguu-core-logs
# Zeeguu-Web
ENV ZEEGUU_WEB_CONFIG=/opt/Zeeguu-Web/default_web.cfg
# Teacher-Dashboard
ENV TEACHER_DASHBOARD_CONFIG=/opt/Zeeguu-Teacher-Dashboard/teacher_dashboard/default.cfg
ENV ZEEGUU_API=$ZEEGUU_API

RUN a2enmod rewrite

CMD  /usr/sbin/apache2ctl -D FOREGROUND

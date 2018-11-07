FROM python:3.6

# Install apache2
RUN apt-get update
RUN apt-get install -y \
    apache2 \
    apache2-dev

# Install zeeguu-web
COPY Zeeguu-Web /opt/Zeeguu-Web
WORKDIR /opt/Zeeguu-Web
RUN pip install -r requirements.txt
RUN python setup.py install

COPY ./apache-zeeguu.conf /etc/apache2/sites-available/apache-zeeguu.conf
RUN a2ensite apache-zeeguu
RUN a2enmod headers

# Install an up to date wsgi
RUN pip install mod_wsgi
RUN /bin/bash -c 'mod_wsgi-express install-module | tee /etc/apache2/mods-available/wsgi.{load,conf}'
RUN a2enmod wsgi

# Copy over the files
RUN cp -r /opt/Zeeguu-Web /var/www/zeeguu-web

# Fix permissions
RUN chown -R www-data /var/www
RUN chgrp -R www-data /var/www
# TODO: fix zeeguu-core to avoid this
RUN mkdir /usr/local/var
RUN chown -R www-data /usr/local/var
RUN chgrp -R www-data /usr/local/var

RUN a2dissite 000-default.conf
RUN a2ensite apache-zeeguu.conf

ENV PYTHONPATH=/usr/local/lib/python3.6/site-packages:/var/www/zeeguu-web

EXPOSE 80

WORKDIR /var/www/zeeguu-web

ENV ZEEGUU_WEB_CONFIG=/opt/Zeeguu-Web/default_web.cfg

CMD  /usr/sbin/apache2ctl -D FOREGROUND

# CMD ["python", "-m", "zeeguu_web"]

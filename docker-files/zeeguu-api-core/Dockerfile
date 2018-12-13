FROM python:3.6

# Update and install additional tools
RUN apt-get update
RUN apt-get install vim -y

# Install Zeeguu-Core
COPY Zeeguu-Core /opt/Zeeguu-Core
WORKDIR /opt/Zeeguu-Core
RUN pip install -r requirements.txt
RUN python setup.py install

# Install Zeeguu-API
COPY Zeeguu-API /opt/Zeeguu-API
WORKDIR /opt/Zeeguu-API
RUN pip install -r requirements.txt
RUN python setup.py install

# Set default path to config
ENV ZEEGUU_CORE_CONFIG=/opt/Zeeguu-Core/default_core.cfg
ENV ZEEGUU_API_CONFIG=/opt/Zeeguu-API/default_api.cfg
ENV ZEEGUU_CORE_LOG_DIR=/tmp/zeeguu-core-logs
# TODO: Check if this is still required
# RUN python -m zeeguu.populate

WORKDIR /opt/Zeeguu-API

CMD ["python", "zeeguu_api"]

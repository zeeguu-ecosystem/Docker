FROM zeeguu-api-core

# Copy updated Zeeguu-Core
COPY Zeeguu-Core /opt/Zeeguu-Core
WORKDIR /opt/Zeeguu-Core
RUN python setup.py install

# Copy updated Zeeguu-API
COPY Zeeguu-API /opt/Zeeguu-API
WORKDIR /opt/Zeeguu-API
RUN python setup.py install

WORKDIR /opt/Zeeguu-API

CMD ["python", "zeeguu_api"]

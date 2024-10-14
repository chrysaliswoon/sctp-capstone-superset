FROM apache/superset:4.0.2

USER root
RUN apt-get update && apt-get install -y sudo vim \
    && pip install "PyAthena[SQLAlchemy]" "pyathena[pandas]" "PyAthenaJDBC" 
    #&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY superset_config.py /app/
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

RUN mkdir -p /data/superset/

USER superset

RUN superset db upgrade && superset init 

RUN superset fab create-admin \
    --username admin \
    --firstname admin \
    --lastname admin \
    --email admin@gmail.com \
    --password admin

EXPOSE 8088

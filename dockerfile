# Use the official Apache Superset image as the base
# FROM apache/superset:latest
FROM apache/superset:3.1.3

# Install dependencies for Athena
USER root
RUN apt-get update && apt-get install -y sudo vim \
    && pip install "PyAthena[SQLAlchemy]" \
    && pip install "pyathena[pandas]" \
    && pip install "PyAthenaJDBC"  

# Add the superset_config.py file from the current directory
# this helps us to overide default parameters and configurations
COPY superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

RUN mkdir -p /data/superset/

# Switch back to the superset user
USER superset

RUN superset db upgrade && superset init \
    && superset fab create-admin \
        --username admin \
        --firstname admin \
        --lastname admin \
        --email admin@gmailcom \
        --password admin

# Expose the port that superset runs on
EXPOSE 8088

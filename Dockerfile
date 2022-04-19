FROM postgres:latest

RUN apt-get update && \
        apt-get -y upgrade && \
        apt-get -y install gnupg apt-transport-https lsb-release wget nano

## Timescaledb
# https://packagecloud.io/timescale/timescaledb
RUN wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add -

RUN echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/timescaledb.list

RUN apt-get -q update && \
        apt-get -y install timescaledb-2-postgresql-14
        # timescaledb-toolkit-postgresql-14
#RUN sed -r -i "s/[#]*\s*(shared_preload_libraries)\s*=\s*'(.*)'/\1 = 'timescaledb,\2'/;s/,'/'/" /usr/share/postgresql/postgresql.conf.sample
# extension "timescaledb" must be preloaded
RUN echo "shared_preload_libraries = 'timescaledb'" >> /usr/share/postgresql/postgresql.conf.sample
# telemetry off
RUN echo "timescaledb.telemetry_level=off" >> /usr/share/postgresql/postgresql.conf.sample

## Postgis
# https://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24UbuntuPGSQL10Apt
# 
RUN apt-get -q update && \
        apt-get -y install postgresql-14-postgis-3 \
        postgresql-14-postgis-3-scripts \
        postgresql-14-pgrouting \
        postgresql-14-pgrouting-scripts

## Extension plpython3
RUN apt-get -y install python3 postgresql-plpython3-14 python3-requests

RUN rm -rf /var/lib/apt/lists/*

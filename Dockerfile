FROM python:3.7-slim-buster

ENV ECCODES_VERSION 2.13.1

RUN apt-get update \
    && apt-get install -y libhdf5-dev libjpeg-dev libjpeg62-turbo libjpeg62-turbo-dev libopenjp2-7-dev libnetcdf-dev libpng-dev linux-libc-dev zlib1g-dev libc-dev-bin libc6-dev libgomp1 libquadmath0 gcc gfortran wget cmake git \
    && pip install cython numpy
WORKDIR /tmp
RUN rm -rf /tmp/* \
    && cd /tmp \
    && wget http://shdh.ca/eccodes-2.13.1-Source.tar.gz \
    && tar xvzf /tmp/eccodes-${ECCODES_VERSION}-Source.tar.gz \
    && rm /tmp/eccodes-2.13.1-Source.tar.gz \
    && mkdir build
WORKDIR /tmp/build
RUN cd /tmp/build \
    && cmake /tmp/eccodes-${ECCODES_VERSION}-Source \
    && make \
    && make install \
    && pip install eccodes-python \
    && apt-get remove -y libhdf5-dev libjpeg-dev libjpeg62-turbo libjpeg62-turbo-dev libopenjp2-7-dev libnetcdf-dev libpng-dev linux-libc-dev zlib1g-dev libc-dev-bin libc6-dev libgomp1 libquadmath0 gcc gfortran wget cmake git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \
    && cd /root
WORKDIR /root
ENV LD_LIBRARY_PATH "/tmp/build/lib/" 
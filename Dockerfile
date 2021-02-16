FROM python:3.8-alpine3.10
LABEL maintainer=v.stone@163.com

RUN apk add --no-cache bash chromium chromium-chromedriver openjdk8-jre

ENV VERSION=2.13.8
WORKDIR /opt
ADD https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${VERSION}/allure-commandline-${VERSION}.tgz .
RUN tar zvxf allure-commandline-${VERSION}.tgz \
    && ln -s /opt/allure-${VERSION}/bin/allure /usr/bin/allure \
    && rm -rf allure-${VERSION}.tgz \
    && allure --version

ADD requirements.txt ./
RUN apk add --no-cache --virtual .build-deps \
        gcc libc-dev libffi-dev make openssl-dev tzdata musl-dev python-dev postgresql-dev && \
    pip install -r requirements.txt && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del .build-deps

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv

WORKDIR /workspace
ENV PYTHONPATH=/workspace

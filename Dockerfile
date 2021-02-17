FROM bxwill/allure:2.13.8 AS allure

FROM python:3.8-alpine3.10
LABEL maintainer=v.stone@163.com
ENV VERSION=2.13.8
WORKDIR /workspace
ENV PYTHONPATH=/workspace

COPY --from=allure /opt/allure-${VERSION} /opt/allure
COPY requirements.txt ./
RUN apk add --no-cache bash chromium chromium-chromedriver openjdk8-jre \
    && apk add --no-cache --virtual .build-deps \
        gcc libc-dev libffi-dev make openssl-dev tzdata musl-dev python-dev postgresql-dev \
    && pip install -r requirements.txt \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del .build-deps \
    && ln -s /opt/allure/bin/allure /usr/bin/allure \
    && allure --version

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv


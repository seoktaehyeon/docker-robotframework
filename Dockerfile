FROM python:3.8-alpine3.10
LABEL maintainer=v.stone@163.com
WORKDIR /workspace

ADD requirements.txt ./

RUN apk add --no-cache bash chromium chromium-chromedriver

RUN apk add --no-cache --virtual .build-deps \
        gcc libc-dev libffi-dev make openssl-dev tzdata musl-dev python-dev postgresql-dev && \
    pip install -r requirements.txt && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del .build-deps

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv
ENV PYTHONPATH=/workspace

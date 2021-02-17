FROM python:3.7-alpine3.10
LABEL maintainer=v.stone@163.com
WORKDIR /workspace
ENV PYTHONPATH=/workspace

ADD requirements.txt ./
ADD sanity_check.robot /tmp/sanity_check.robot

RUN apk add --no-cache chromium chromium-chromedriver

RUN apk add --no-cache --virtual .build-deps \
        gcc libc-dev libffi-dev make openssl-dev tzdata musl-dev python-dev postgresql-dev && \
    pip install -r requirements.txt && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del .build-deps && \
    [[ -f /usr/local/bin/pybot ]] || ln -s /usr/local/bin/robot /usr/local/bin/pybot

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv

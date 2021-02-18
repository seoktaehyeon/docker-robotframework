ARG ALLURE_VER=2.13.8
FROM bxwill/allure:${ALLURE_VER} AS allure

FROM python:3.8-alpine3.10
LABEL maintainer=v.stone@163.com
WORKDIR /workspace
ENV PYTHONPATH=/workspace

COPY --from=allure /opt/allure /opt/allure
COPY requirements.txt ./
RUN apk add --no-cache bash chromium chromium-chromedriver openjdk8-jre \
    && apk add --no-cache --virtual .build-deps \
        gcc libc-dev libffi-dev make openssl-dev tzdata musl-dev python-dev postgresql-dev \
    && python -m pip install --upgrade pip \
    && pip install -r requirements.txt \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del .build-deps \
    && ln -s /opt/allure/bin/allure /usr/bin/allure \
    && allure --version

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv

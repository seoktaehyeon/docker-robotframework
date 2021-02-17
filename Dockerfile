FROM ubuntu:18.04
LABEL maintainer=v.stone@163.com
WORKDIR /workspace
ENV PYTHONPATH=/workspace

ADD requirements.txt ./
ADD sanity_check.robot /tmp/sanity_check.robot

RUN apt update && \
    apt install -y python3.7 python3-pip firefox curl wget && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    gecko_url=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases | grep assets_url | head -1 | awk -F "\"" '{print $4}') && \
    gecko_download=$(curl -s $gecko_url | grep browser_download_url | grep linux64 | awk -F "\"" '{print $4}') && \
    wget $gecko_download -O geckodriver.tar.gz && \
    tar zxvf geckodriver.tar.gz -C /usr/local/bin/ && \
    rm -rf geckodriver.tar.gz

RUN pip install -r requirements.txt && \
    [[ -f /usr/local/bin/pybot ]] || ln -s /usr/local/bin/robot /usr/local/bin/pybot

ADD 微软雅黑.ttf /usr/share/fonts
RUN fc-cache -fv

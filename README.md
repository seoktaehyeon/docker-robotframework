# Docker images for DCS RobotFramework task

#### Background
> DCS test project has RobotFramework pipeline task, they need some docker images to run RobotFramework scripts. Build some images for Python+Chrome and Python+Firefox scenarios. As we known, most of RobotFrameworkers want to test Web UI leverage Selenium, so we add selenium into these images and support Chinese.

#### Dockerfile for py-chrome-dcs
```Dockerfile
FROM python:3.7-alpine3.10
MAINTAINER v.stone@163.com
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
```
#### Requirements
```text
requests>=2.19.1
pyyaml>=5.1
selenium>=3.14.0
robotframework>=3.1.1
robotframework-requests>=0.5.0
robotframework-selenium2library>=3.0.0
```

#### Try
- Run headless browser in Selenium
```bash
docker run --rm -it bxwill/robotframework:py-chrome-dcs python -c "from selenium import webdriver; opts=webdriver.ChromeOptions(); opts.add_argument('--headless'); opts.add_argument('--no-sandbox'); bs=webdriver.Chrome(options=opts); bs.get('http://bx.baoxian-sz.com'); print(bs.title)"
```
- Run headless browser in RobotFramework
```bash
docker run --rm -it bxwill/robotframework:py-chrome-dcs robot /tmp/sanity_check.robot
```
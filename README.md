# Docker images for DCS RobotFramework task

#### Background
> DCS test project has RobotFramework pipeline task, they need some docker images to run RobotFramework scripts. Build some images for Python+Chrome and Python+Firefox scenarios. As we known, most of RobotFrameworkers want to test Web UI leverage Selenium, so we add selenium into these images and support Chinese.

#### Dockerfile for py-firefox-dcs
```Dockerfile
FROM ubuntu:18.04 AS download
WORKDIR /workspace
RUN apt update \
    && apt install -y curl wget \
    && gecko_url=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases | grep assets_url | head -1 | awk -F '"' '{print $4}') \
    && gecko_download=$(curl -s $gecko_url | grep browser_download_url | grep 'linux64.tar.gz"' | awk -F '"' '{print $4}') \
    && wget $gecko_download -O geckodriver.tar.gz \
    && tar zxvf geckodriver.tar.gz

FROM ubuntu:18.04
LABEL maintainer=v.stone@163.com
WORKDIR /workspace
ENV PYTHONPATH=/workspace
COPY requirements.txt requirements.txt
COPY sanity_check.robot /tmp/sanity_check.robot
COPY --from=download /workspace/geckodriver /usr/local/bin/geckodriver
RUN apt update \
    && apt install -y python3.7 python3-pip firefox \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && python -m pip install --upgrade pip \
    && pip install -r requirements.txt \
    && [[ -f /usr/local/bin/pybot ]] || ln -s /usr/local/bin/robot /usr/local/bin/pybot
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
docker run --rm -it bxwill/robotframework:py-firefox-dcs python -c "import sys, io; sys.stdout=io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8'); from selenium import webdriver; opts=webdriver.FirefoxOptions(); opts.add_argument('--headless'); opts.add_argument('--no-sandbox'); bs=webdriver.Firefox(options=opts); bs.get('https://office.baoxian-sz.com'); print(bs.title)"
```
- Run headless browser in RobotFramework
```bash
docker run --rm -it bxwill/robotframework:py-firefox-dcs robot /tmp/sanity_check.robot
```

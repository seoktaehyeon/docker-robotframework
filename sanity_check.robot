*** Settings ***
Documentation                   Example for RobotFramework + Python + Firefox
Library                         Selenium2Library


*** Variables ***
${ACCESS_URL}                   https://office.baoxian-sz.com


*** Test Cases ***
Access Web Site
    Open Browser To Access Page   ${ACCESS_URL}
    Title Should Contain        Truth & Insurance Office
    [Teardown]      Close Browser


*** Keywords ***
Open Browser To Access Page
    [Arguments]        ${url}
    ${opts}                   Evaluate      sys.modules['selenium.webdriver'].FirefoxOptions()      sys, selenium.webdriver
    Call Method         ${opts}         add_argument        --headless
    Call Method         ${opts}         add_argument        --no-sandbox
    Create Webdriver    Firefox       firefox_options=${opts}
    Go To                       ${url}

Title Should Contain
    [Arguments]         ${text}
    ${title}                     Get Title
    Should Contain   ${title}        ${text}
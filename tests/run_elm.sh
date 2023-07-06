#!/bin/bash
ruby -e 'require "selenium-webdriver";
d=Selenium::WebDriver.for(:chrome);
d.get("file://'"$PWD/${1%.*}_elm.html"'");
puts d.find_elements(tag_name:"body")[0].text;
d.quit'

#!/bin/bash
bundle install --path vendor/bundle >& /dev/null
bundle exec ruby -e 'require "selenium-webdriver"; Selenium::WebDriver.for(:firefox).tap{|d| d.get("file://'"$PWD/build/${1%.*}.html"'"); puts d.find_elements(tag_name:"div")[1].text}.quit'

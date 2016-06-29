#!/bin/bash
(bundle install --path vendor/bundle >& /dev/null
bundle exec selenium install) >/dev/null 2>&1
bundle exec ruby -e 'require "selenium-webdriver";
d=Selenium::WebDriver.for(:chrome);
d.get("file://'"$PWD/${1%.*}_elm.html"'");
puts d.find_elements(tag_name:"body")[0].text;
d.quit'

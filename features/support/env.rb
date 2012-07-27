require "bundler/setup"
 
require 'capybara/mechanize'
require 'capybara/cucumber'

#
# app and app_host are set via command line parameter on cucumber call:
#   cucumber HOST=33.33.33.10
#
host= ENV['HOST']
host ||= '33.33.33.10'
Capybara.app = host
Capybara.run_server = false
Capybara.app_host = host
Capybara.default_selector = :css
Capybara.default_driver = :mechanize
# Capybara.default_driver = :selenium

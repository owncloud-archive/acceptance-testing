require "bundler/setup"
 
#require 'capybara/mechanize'
require 'capybara/cucumber'
require 'ruby-debug'

Encoding.default_internal = Encoding::UTF_8

#Browser switch
browser_type = ENV['BROWSER']
browser_type ||= 'firefox'
case browser_type
when "firefox"
  require 'selenium-webdriver'
  Capybara.default_driver = :selenium
  Capybara.javascript_driver = :selenium
when "webkit"
  require 'capybara-webkit'
  Capybara.default_driver = :webkit
  Capybara.javascript_driver = :webkit
end

Capybara.register_driver :selenium do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 200
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
end

host= ENV['HOST']
host ||= '33.33.33.10'
Capybara.app = host
Capybara.run_server = false
Capybara.app_host = "http://#{host}"
Capybara.default_selector = :css

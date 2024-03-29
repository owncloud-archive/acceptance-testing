# encoding: utf-8
require "bundler/setup"
 
#require 'capybara/mechanize'
require 'capybara/cucumber'
require 'ruby-debug'

Encoding.default_internal = Encoding::UTF_8

Capybara.default_wait_time = 6

#Browser switch
browser_type = ENV['BROWSER']
browser_type ||= 'firefox'
case browser_type
when "firefox"
  require 'selenium-webdriver'
  Capybara.default_driver = :selenium
  Capybara.javascript_driver = :selenium
  Capybara.register_driver :selenium do |app|
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 200
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
  end

when "webkit"
  require 'capybara-webkit'
  Capybara.default_driver = :webkit
  Capybara.javascript_driver = :webkit

when "poltergeist"
    require 'capybara/poltergeist'
 
    Capybara.default_driver = :poltergeist
    Capybara.register_driver :poltergeist do |app|
        options = {
            :js_errors => false,
            :timeout => 120,
            :debug => false,
#            :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
            :inspector => true,
        }
        Capybara::Poltergeist::Driver.new(app, options)
    end
end

#Headless switch
headless = ENV['HEADLESS']
headless ||= 'false'
if headless == 'true'
  require 'headless'

  headless = Headless.new #(:display => 99999)
  headless.start

  at_exit do
    headless.destroy
  end
end

host= ENV['HOST']
host ||= '33.33.33.10'
Capybara.app = host
Capybara.run_server = false
Capybara.app_host = "http://#{host}"
Capybara.default_selector = :css

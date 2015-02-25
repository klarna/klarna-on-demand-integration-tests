# Copy all the stuff from here: https://github.com/appium/sample-code/blob/master/sample-code/examples/ruby/cucumber_ios/features/support/env.rb

require 'rspec/expectations'
require 'appium_lib'
require 'cucumber/ast'

# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld
end

# Set default per-platform capabilities
capabilities = {
  app:             ENV['APP_LOCATION'] || (raise 'Please specify the app\'s location')
}

platformName = ENV['PLATFORM'] || (raise 'Please supply the desired platform')

case platformName.downcase.to_sym
when :ios
  capabilities.merge!({
    platformName:    'iOS',
    deviceName:      ENV['DEVICE_NAME'] || 'iPhone Simulator',
    platformVersion: ENV['PLATFORM_VERSION'] || '8.1'
  })
when :android
  capabilities.merge!({
    platformName:    'Android',
    deviceName:      ENV['DEVICE_NAME'] || 'Android Emulator',
    platformVersion: ENV['PLATFORM_VERSION'] || '4.4'
  })

  capabilities[:automationName] = 'Selendroid' if ENV['TRAVIS']
end

options = {}

# Set Travis specific shared options/capabilities
if (ENV['TRAVIS'])
  auth_data = "#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}"
  options[:appium_lib] = { server_url: "http://#{auth_data}@ondemand.saucelabs.com/wd/hub" }

  capabilities['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
  capabilities[:appiumVersion] = '1.3.4'
  capabilities['record-video'] = false
  capabilities[:browserName] = ''
end

options[:caps] = capabilities

Appium::Driver.new(caps: capabilities)
Appium.promote_appium_methods AppiumWorld

World do
  AppiumWorld.new
end

Before { $driver.start_driver }
After { $driver.driver_quit }

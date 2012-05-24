require 'rubygems'
require 'rspec'
require "#{File.dirname(__FILE__)}/../lib/sk_api"

puts "Testing with ActiveResource Version: #{ActiveResource::VERSION::STRING}. Make sure this matches the version in your app. .. Yes this sucks!"

def delete_test_data(doc, client)
  doc.destroy
  client.destroy
  lambda {
    doc = SKApi::Resources::Invoice.find(doc.id)
  }.should raise_error(ActiveResource::ResourceNotFound)
  lambda {
    client = SKApi::Resources::Client.find(client.id)
  }.should raise_error(ActiveResource::ResourceNotFound)
end

SKApi::CONNECTION = {
    :site => "http://demo.salesking.local:3000/api/",
    :user => "demo@salesking.eu",
    :password => "demo",
    #:site => "https://demo.dev.salesking.eu/api/",
    #:user => "demo@salesking.eu",
    #:password => "",
    :format => :json
  } unless defined?(SKApi::CONNECTION)
SKApi::Resources::Base.set_connection(SKApi::CONNECTION)


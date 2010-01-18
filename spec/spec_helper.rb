require 'rubygems'
require 'spec'
require "#{File.dirname(__FILE__)}/../lib/sk_api"

##
SKApi::CONNECTION = {
    :site => "http://my-sub.salesking.domain/api/",
    :user => "a user",
    :password => "well .. a password",
    :format => :json
  }
SKApi::Resources::Base.set_connection(SKApi::CONNECTION)
ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require File.expand_path("vendor/dependencies/lib/dependencies", File.dirname(__FILE__))
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "ohm"
require "ohm/contrib"  # commented out because not using validations right now
require "haml"
require "sass"
require root_path("app/helpers/cloudvox_sip.rb")
require "will_paginate"
require "will_paginate/view_helpers/base"
require "will_paginate/view_helpers/link_renderer"

WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected
  def url(page)
    url = @template.request.url
    if page == 1
      # strip out page param and trailing ? if it exists
      url.gsub(/\/[0-9]+/, '').gsub(/\/$/, '')
    else
      if url =~ /\/[0-9]+/
        url.gsub(/\/[0-9]+/, "\/#{page}")
      else
        url + "#{page}"
      end      
    end
  end
end

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
  #Ohm.connect(:url => "redis://heroku:8b3d3faf9ecdc51696a2749160614c29@filefish.redistogo.com:9167/")
  logger.info "--------------------------"
  logger.info "Starting app"
  logger.info "--------------------------"
end

# Connect to redis database.
Ohm.connect(monk_settings(:redis))

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?

ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require File.expand_path("vendor/dependencies/lib/dependencies", File.dirname(__FILE__))
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "ohm"
#require "ohm/contrib"  # commented out because not using validations right now
require "haml"
require "sass"
require root_path("app/helpers/cloudvox_sip.rb")

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
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

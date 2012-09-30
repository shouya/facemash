
require './app'

set :environment, ENV['RACK_ENV'].intern
#set :app_file,     'app.rb'
disable :run

log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application



require 'sinatra'
require 'base64'
require 'json'

require_relative 'dbinterface'

before do
  @dbi = connect_database
end

get '/' do
  erb :mainpage
end

post '/rate' do
  params['winner']
  params['loster']
end

get '/refresh' do
  content_type :json
  return JSON.dump({
                     :pic_left => {
                       :data => Base64.encode64(File.read('temp/0111348.jpg')),
                       :id => 1,
                       :info => 'Katie'
                     },
                     :pic_right => {
                       :data => Base64.encode64(File.read('temp/0111437.jpg')),
                       :id => 3,
                       :info => 'Lily'
                     }
                   })
end




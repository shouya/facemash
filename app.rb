
require 'sinatra'
require 'base64'
require 'json'

require_relative 'dbinterface'

before do
  @dbi = Database.new
end

get '/' do
  redirect to('/main.html')
end

get '/main.html' do
  erb :mainpage
end

post '/vote' do
#  params['id']
end

get '/refresh' do
  content_type :json

  json_hash = @dbi.random_pick

  json_hash.each do |_,v|
    v[:data] = Base64.encode64 File.read(File.join('photo',
                                                   v.delete(:barcode) + '.jpg'))

  end
=begin
  {
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
  }
=end
  return JSON.dump(json_hash)
end




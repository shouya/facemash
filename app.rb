
require 'sinatra'

require_relative 'dbinterface'

before do
  @dbi = get_db
end

get '/' do
  erb :mainpage
end

post '/rate' do
  params['winner']
  params['loster']
end

post '/anotherpic' do

end




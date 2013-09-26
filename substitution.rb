['sinatra','rubygems','haml'].each do |lib|
    require lib
end

require './config.rb' #some configuration options
require './models/index.rb' #this script loads data mapper
require './sections/auth.rb'
require './sections/submit'
require './sections/list'

get '/' do
   haml :home
end


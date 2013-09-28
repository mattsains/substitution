['sinatra','rubygems','haml'].each do |lib|
    require lib
end

require './config.rb' #some configuration options
require './models/index.rb' #this script loads data mapper
require './sections/auth.rb'
require './sections/submit.rb'
require './sections/list.rb'
require './sections/assign.rb'
get '/' do
   haml :home
end


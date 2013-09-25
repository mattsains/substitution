['sinatra','rubygems','haml'].each do |lib|
    require lib
end

require './config.rb' #some configuration options
require './models/index.rb' #this script loads data mapper
require './sections/auth.rb'

get '/' do
   @teacher=Teacher.current(request)
   #@teacher=Teacher.get(request['REMOTE_USER']);
   haml :home
end

require './sections/submit'

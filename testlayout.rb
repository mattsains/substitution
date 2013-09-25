require 'sinatra'
require 'haml'
#set :environment, :production
get '/' do
  @title="Subheading"
  haml :timetable
end

post '/' do
   
end
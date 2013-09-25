get '/submit' do
   @title="File for substitution"
   haml :subbasic
end
DataMapper::Model.raise_on_save_failure = true
post '/submit' do
   teacher=Teacher.first_or_create(:code=>"MS")
   submission=Submission.create(:reason=>request['reason'], :teacher=>teacher)
   "Done!"
end

get '/submit/assign' do
   @title="Assign Work"
   @date=
   haml :timetable
end

post '/submit/assign' do
   #got info from timetable form
end
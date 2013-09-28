DataMapper::Model.raise_on_save_failure = true

get '/submit' do
   @title="File for substitution"
   @err=request['err'] || nil
   haml :subbasic
end

post '/submit' do
   submission=Submission.create(:reason=>request['reason'], :teacher=>@teacher)
   redirect '/submit/assign?date='+Date.parse(request['date']).to_s
end

get '/submit/assign' do
   teacher=Teacher.current(request)
   submission=Submission.first(:teacher=>teacher, :inprog=>true)
   if !submission
      redirect '/submit'
   else
      @title="Assign Work"
      begin
         @date=Date.parse(request['date'])
      rescue
         @date=Date.today
      end
      @date=Date.commercial(@date.year,@date.cweek,1)
      periods=Period.all(:submission=>submission, :date=>(@date..@date.next_day(5)))
      
      @periods=[]
      5.times { @periods<<Array.new(11) }
      
      periods.each do |period|
         
         @periods[period.date-@date][period.period]={:room=>period.room, :work=>period.work}
      end
      haml :timetable
   end
end

post '/submit/assign' do
   #got info from timetable form
   date=Date.parse(request['date'])
   submission=Submission.first(:teacher=>Teacher.current(request), :inprog=>true)
   Period.transaction do |t|
      begin
         5.times do |d|
            12.times do |p|
               if work=request['timetable'][(d+1).to_s][(p).to_s]
                  if !work.empty?
                     period=Period.first(:date=>date, :period=>p, :submission=>submission)
                     if period.nil?
                        Period.create(:date=>date, :period=>p, :room=>request['rooms'][(d+1).to_s][(p).to_s], 
                                      :work=>request['timetable'][(d+1).to_s][(p).to_s], :submission=>submission)
                     else
                        period.update(:room=>request['rooms'][(d+1).to_s][(p).to_s], 
                                      :work=>request['timetable'][(d+1).to_s][(p).to_s])
                     end
                  end
               end
            end
            date+=1
         end
      rescue DataMapper::SaveFailureError => e
         puts e.resource.errors.inspect
         t.rollback
      end
   end
   
   case request['direction']
      when 'next'
         redirect '/submit/assign?date='+(Date.parse(request['date'])+7).to_s
      when 'prev'
         redirect '/submit/assign?date='+(Date.parse(request['date'])-7).to_s
      else
         submission.update(:inprog=>false)
         redirect('/list/substitution?new=1&id='+submission.id.to_s)
   end
end
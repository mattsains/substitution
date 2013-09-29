DataMapper::Model.raise_on_save_failure = true

get '/submit' do
   @title="File for substitution"
   haml :subbasic
end

post '/submit' do
   begin
      submission=Submission.create(:reason=>request['reason'], :teacher=>@teacher)
      redirect '/submit/assign?date='+Date.parse(request['date']).to_s
   rescue ArgumentError
      @title="File for substitution"
      @err="Invalid date \"#{request['date']}\""
      haml :subbasic
   end
end

get '/submit/assign' do
   submission=Submission.first(:teacher=>@teacher, :inprog=>true)
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
      5.times { @periods<<Array.new(12) }
      
      periods.each do |period|
         @periods[period.date-@date][period.period]={:room=>period.room, :work=>period.work}
      end
      @periods.each_with_index {|x,i| puts "[#{i}:#{x}]"}
      haml :timetable
   end
end

post '/submit/assign' do
   #got info from timetable form
   date=Date.parse(request['date'])
   date=Date.commercial(date.year,date.cweek,1) #round off to monday
   
   submission=Submission.first(:teacher=>Teacher.current(request), :inprog=>true)
   Period.transaction do |t|
      begin
         5.times do |d|
            12.times do |p|
               if work=request['timetable'][(d+1).to_s][(p).to_s]
                  if !work.empty?
                     period=Period.first(:date=>date+d, :period=>p, :submission=>submission)
                     if period.nil?
                        Period.create(:date=>date+d, :period=>p, :room=>request['rooms'][(d+1).to_s][(p).to_s], 
                                      :work=>request['timetable'][(d+1).to_s][(p).to_s], :submission=>submission)
                     else
                        period.update(:room=>request['rooms'][(d+1).to_s][(p).to_s], 
                                      :work=>request['timetable'][(d+1).to_s][(p).to_s])
                     end
                  end
               end
            end
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
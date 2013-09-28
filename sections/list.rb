get '/list' do
   @title="List Substitution"
   haml :sublistoptions
end

get '/list/all' do
   if @teacher.admin
      if request['code'] && teacher=Teacher.get(request['code'])
         @title="List of Substitution from #{teacher.name}"
         @submissions=Submission.all(:inprog=>false, :teacher=>teacher)
      else
         @title="List of all Substitution"
         @submissions=Submission.all(:inprog=>false)
      end
   else
      @title="List of your substitution"
      @submissions=Submission.all(:teacher=>@teacher)
   end
   
   @submissions.sort! {|x,y| y.days<=>x.days}
   haml :sublist
end

get '/list/substitution' do
   if request['date'] && date=Date.parse(request['date'])
      #Show only a certain date (in the table format)
      @periods=Period.all(:date=>date, :order=>[:period.asc])
      @title="Substitution for "+date.strftime('%A, %-d %b %Y')
      @date=date
      @view=:table
      haml :subsummary
   elsif request['id'] && @submission=Submission.get(params['id'])
      #Show a single submission all at once - used for when teachers submit substitution
      if @teacher==@submission.teacher || @teacher.admin
         @title="Substitution Submission"
         @periods=Period.all(:submission=>@submission, :order=>[:period.asc])
         @view=(request['new'] && :new)|| :simpledate
         haml :subsummary
      else
         status 404
      end
   else
      status 404
   end
end


helpers do
   def group_by_date(periods)
      return group_by(periods) {|p| p.date}
   end
   
   def group_by_teacher(periods)
      return group_by(periods) {|p| p.submission.teacher}
   end
   
   def group_by(periods)
      output={}
      periods.each do |period|
         criteria=yield(period)
         output[criteria]||=[]
         output[criteria]<<period
      end
      return output
   end
end
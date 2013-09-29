get '/assign' do
   if request['date']
      begin
         #Show only a certain date (in the assign[table] format)
         @date=Date.parse(request['date'])
         @periods=Submission.all(:inprog=>false).periods.all(:date=>@date, :order=>[:period.asc])
         @title="Substitution for "+@date.strftime('%A, %-d %b %Y')
         @view=:assign
         substitutesarray=@periods.map do |period|
            if period.substitute
               [period.id, period.substitute.code]
            else
               [period.id, ""]
            end
         end
         @substitutes=Hash[substitutesarray]
         haml :subsummary
      rescue ArgumentError
         @title="Assign Substitution"
         @err="Invalid date \"#{request['date']}\""
         haml :assigndate
      end
   else
      @title="Assign Substitution"
      haml :assigndate
   end
end

post '/assign' do
   if request['substitutes']
      substitutes=request['substitutes'].delete_if {|p,sub| sub.empty?}
      periodfail=false #tracks error states
      subfail=[]
      substitutes.each do |pid,sid|
         period=Period.get(pid)
         if !period
            periodfail=true
            next
         end
         
         sub=Teacher.get(sid)
         if !sub
            subfail<<sid
            next
         end
         #now we have a valid teacher and period
         period.substitute=sub
         period.save
      end
      if periodfail
         @msg="One or more periods you tried to assign does not exist"
         haml :staticmsg
      end
      if !subfail.empty?
         @msg=subfail.join(", ")+" are not valid teacher codes"
         haml :staticmsg
      end
      date=Date.parse(request['date'])
      redirect "/list/substitution?date=#{date}"
   else
      status 404
   end
end
use Rack::Auth::Basic, "Substitution System" do |username,password|
   false
   if teacher=Teacher.get(username)
      if teacher.correct? password
         true
      end
   end
end

before do
   @teacher=Teacher.current(request)
end

get '/auth/passwd' do
   if request['code'].nil?
      @teacherchange=@teacher
      haml :authpasswd
   elsif @teacher.admin
      @noverify=true
      @teacherchange=Teacher.get(request['code'])
      if @teacherchange
         haml :authpasswd
      else
         status 404
      end
   else
      status 403 #access denied
   end
end

post '/auth/passwd' do
   if request['code'].nil?
      if @teacher.correct? request['current']
         changepasswd(@teacher, request['new'], request['new2'])
      else
         @err={:current=>"Current password incorrect!"}
         @teacherchange=@teacher
         haml :authpasswd
      end
   elsif @teacher.admin
      @noverify=true
      teacher=teacher.get(params['code'])
      if teacher.nil?
         status 404
      else
         changepasswd(teacher, request['new'], request['new2'])
      end
   else
      status 403 #access denied
   end
end

def changepasswd(teacher, new, new2)
   if new.length>4
      if new==new2
         teacher.password=new
         if teacher.save
            @msg="Password changed successfully for #{teacher.name}"
            haml :staticmsg
         else 
            @msg="Failed to change password"
            haml :staticmsg
         end
      else
         @err={:new=>"Passwords do not match!"}
         @teacherchange=teacher
         haml :authpasswd
      end
   else
      @err={:new=>"New password must be longer than four characters"}
      @teacherchange=teacher
      haml :authpasswd
   end
end

get '/auth/list' do
   if @teacher.admin
      @teachers=Teacher.all
      haml :authlist
   else
      status 403 #access denied
   end   
end

get '/auth/delete' do
   if @teacher.admin
      if request['code'] && @delteacher=Teacher.get(request['code'])
         haml :authdelteacher
      else
         status 404
      end
   else
      status 403 #access denied
   end
end

post '/auth/delete' do
   if @teacher.admin
      if request['code'] && teacher=Teacher.get(request['code'])
         oldname=teacher.name
         teacher.destroy
         @msg="The teacher #{oldname} was deleted"
         haml :staticmsg
      else
         status 404
      end
   else
      status 403 #access denied
   end
end
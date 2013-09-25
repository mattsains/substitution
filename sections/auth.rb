use Rack::Auth::Basic, "Substitution System" do |username,password|
   false
   if teacher=Teacher.get(username)
      if teacher.correct? password
         true
      end
   end
end
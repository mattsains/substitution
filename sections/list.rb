get '/list' do
   if @teacher.admin
      @submissions=Submission.all(:inprog=>false)
   else
      @submissions=Submission.all(:teacher=>@teacher)
   end
   @title="List of Substitution"
   @submissions.sort! {|x,y| y.days<=>x.days}
   haml :sublist
end
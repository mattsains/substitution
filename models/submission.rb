#this is a group of substitution periods that the teacher has filed at once
class Submission
   include DataMapper::Resource
   
   #properties
   property :id,     Serial
   property :reason, Text
   property :inprog, Boolean, :default=>true
   
   belongs_to :teacher
   
   def publish
      @inprog=false
   end
end
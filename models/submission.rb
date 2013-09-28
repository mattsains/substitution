require 'dm-aggregates'
#this is a group of substitution periods that the teacher has filed at once
class Submission
   include DataMapper::Resource
   
   #properties
   property :id,     Serial
   property :reason, Text
   property :inprog, Boolean, :default=>true
   
   belongs_to :teacher
   has n, :periods
   
   def periods
      return Period.count(:submission=>self)
   end
   
   def days
      days=Period.all(:submission=>self).uniq {|x| x.date}
      return days.count
   end
   
   def startdate
      return Period.min(:date, :submission=>self)
   end
   
   def enddate
      return Period.max(:date, :submission=>self)
   end
   
   def publish
      @inprog=false
   end
end
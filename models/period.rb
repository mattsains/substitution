require 'date'
class Period
   include DataMapper::Resource
   
   #properties
   property :id,     Serial
   property :date,   Date
   property :period, Integer
   property :room,   String
   property :work,   Text
   
   belongs_to :submission
   
   belongs_to :substitute, 'Teacher', :required=>false
   validates_with_method :check_date
   
   def check_date
      if self.date.wday.between?(1,6)
        return true
      else
        [ false, "Substitution only makes sense for weekdays" ]
      end
    end
   
   def dayofweek
      return self.date.wday
   end
end
require 'date'
class Period
   include DataMapper::Resource
   
   #properties
   property :id,     Serial,  :key=>true
   property :date,   Date
   property :period, Integer
   property :room,   String
   property :work,   Text
   
   belongs_to :submission
   
   belongs_to :substitute, 'Teacher', :required=>false
   
   validates_with_method :check_date
   validates_with_method :check_period
   validates_with_method :check_substitute
   validates_with_method :check_uniqueness
   
   def check_date
      if self.date.wday.between?(1,6)
         return true
      else
         [false, "Substitution only makes sense for weekdays"]
      end
   end
    
   def check_period
      if self.period.between?(0,12)
         true
      else
         [false, "Periods are between 0 (registration) and 11"]
      end
   end
   
   def check_substitute
      return true if self.substitute.nil?
      
      samesubs=Period.all(:date=>self.date, :period=>self.period, :substitute=>self.substitute)
      if !samesubs.empty?
         if samesubs.length==1 && samesubs.first.id==self.id
            return true
         else
            return [false, "#{self.substitute.name} is already substituting at this time"]
         end
      else
         return true
      end
   end
   
   def check_uniqueness
      sameperiods=Period.all(:date=>self.date, :period=>self.period, :room=>self.room)
      if !sameperiods.empty?
         if sameperiods.length==1 && sameperiods.first.id==self.id
            return true
         else
            return [false, "This period clashes with another in the database"]
         end
      else
         return true
      end
   end
   
   def dayofweek
      return self.date.wday
   end
end
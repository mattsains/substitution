#define all the models here
needs=['teacher','submission','period']

require 'data_mapper'
require 'dm-validations'
DataMapper::Logger.new($stdout,:debug) # displays database errors
DataMapper.setup(:default, $database)

needs.each do |model|
    require_relative "./#{model}.rb"
end

DataMapper.finalize
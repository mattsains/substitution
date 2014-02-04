#This file nukes any database files that should exist and initializes a new, empty database.

require 'rubygems'
require './config.rb'

require './models/index.rb'

DataMapper.auto_upgrade!

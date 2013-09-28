require 'securerandom'
class Teacher
   include DataMapper::Resource
   
   #properties
   property :code,   String, :key=>true, :length=>2
   property :name,   String
   property :admin,  Boolean, :default=>false
   
   property :psw_salt,         String, :accessor=>:private
   property :psw_hash,         String, :accessor=>:private
   
   #validation
   validates_length_of  :code, :min=>2, :max=>2
   
   def correct? (pass)
      return (@psw_hash==hash_psw(pass,@psw_salt))
   end
   
   def password=(value)
      self.psw_salt=SecureRandom.hex
      self.psw_hash=hash_psw(value,@psw_salt)
   end
   
   def self.current(request)
      return get(request.env['REMOTE_USER'])
   end
end

require 'digest/sha1'
def hash_psw(secret,salt)
   secret||=""
   salt||=""
   hashSpin=Digest::SHA1.hexdigest(salt+secret)
   99.times do hashSpin=Digest::SHA1.hexdigest(salt+hashSpin) end
   return hashSpin;
end
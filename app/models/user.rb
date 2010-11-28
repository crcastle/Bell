# adapted from https://github.com/monkrb/reddit-clone/tree/master/app/models/
require 'digest/sha1'
require 'app/helpers/cloudvox_sip'

class User < Ohm::Model
  class WrongUsername < ArgumentError; end
  class WrongPassword < ArgumentError; end
  class CloudvoxAppError < StandardError; end
  
  #include Ohm::ExtraValidations
  
  attribute :username # TODO: make this require an email
  attribute :password # TODO: make this require a minimum length
  attribute :salt
  
  set :voicemails, Voicemail
  set :phones, Phone
  set :numbers, Number
  
  index :username
  
  def validate
    assert_unique :username
  end
  
  def self.authenticate(username, password)
    raise WrongUsername unless user = find(:username => username).first
    raise WrongPassword unless user.password == encrypt(password, user.salt)
    logger.info("logging in user " + username + " (id: " + user.id + ")")
    user
  end
  
  def password=(value)
    write_local(:salt, encrypt(Time.now.to_s, ""))
    
    value = value.empty? ? nil : encrypt(value, salt)
    
    write_local(:password, value)
  end
  
  #def create
  #  @cv = Cloudvox.new
  #  
  #  @json_response = @cv.create_app(user.id, self.phone_owner + "" + self.exten, self.cv_password)
  #  
  #end
  
  # returns an array of Voicemails for this user
  def voicemails_received
    Voicemail.find(:for_user => id)
  end
  
  # returns an array of Phones for this user
  def phones
    Phone.find(:phone_owner => id)
  end
  
  # returns an array of Numbers for this user
  def numbers
    Number.find(:did_owner => id)
  end
  
  def to_s
    username.to_s
  end
  
  def to_param
    username
  end
  
  def get_call_history
    @cv = Cloudvox.new
    @cv.get_call_history("805")
  end
  
private

  def self.encrypt(string, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{string}--")
  end
  
  def encrypt(*attrs)
    self.class.encrypt(*attrs)
  end
end
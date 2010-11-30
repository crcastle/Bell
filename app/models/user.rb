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
  attribute :admin # TODO: assert this to be "true" or "false"
  
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
  def voicemails
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
    # TODO: update the parameter in get_call_history to be dynamic
    @cv = Cloudvox.new
    @cv.get_call_history("805")
  end
  
  def admin?
    (self.admin == "true" || userid_1?) ? true : false
  end
      
  def make_admin!
    self.admin = "true"
  end
  
  def self.username_for(id)
    if id
      User[id].username
    else
      nil
    end
  end
  
private

  def self.encrypt(string, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{string}--")
  end
  
  def encrypt(*attrs)
    self.class.encrypt(*attrs)
  end
  
  def userid_1?
    self.id == "1" ? true : false
  end
end
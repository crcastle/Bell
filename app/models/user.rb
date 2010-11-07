# adapted from https://github.com/monkrb/reddit-clone/tree/master/app/models/
require 'digest/sha1'

class User < Ohm::Model
  class WrongUsername < ArgumentError; end
  class WrongPassword < ArgumentError; end

  attribute :username
  attribute :password
  attribute :salt
  # what else does a user need?
  
  set Voicemail, Phone, Number
  
  index :username
  
  def validate
    assert_present :username
    assert_present :password
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
  
  # returns an array of Voicemails for this user
  def voicemails_received
    Voicemail.find(:for_user, id)
  end
  
  # returns an array of Phones for this user
  def phones
    Phone.find(:phone_owner, id)
  end
  
  # returns an array of Numbers for this user
  def numbers
    Numbers.find(:did_owner, id)
  end
  
  def to_s
    username.to_s
  end
  
  def to_param
    username
  end
  
private

  def self.encrypt(string, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{string}--")
  end
  
  def encrypt(*attrs)
    self.class.encrypt(*attrs)
  end
end
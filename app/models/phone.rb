# represents an endpoint on the system
# could be either a SIP phone or PSTN phone
class Phone < Ohm::Model
  include Ohm::Callbacks
  include Ohm::NumberValidations
  include Ohm::ExtraValidations
  
  class CloudvoxSipError < StandardError; end
  
  attribute :type # "sip" or "regular"
  attribute :exten # SIP extension or PSTN phone number
  attribute :name # user-supplied name for this phone
  attribute :phone_owner # user id of the phone owner
  attribute :cv_id # cloudvox phone id for SIP phones
  attribute :cv_extension
  attribute :cv_username
  attribute :cv_domain
  attribute :cv_password
  attribute :verified
  attribute :verification_code
  
  index :exten
  index :phone_owner
  index :type
  
  before :validate, :assign_sip_exten
  
  def validate
    super
    
    assert_us_phone :exten if (self.is_mobile? || self.is_land?)
    assert_unique :exten if :type == "sip"
    assert_present :name
    assert_numeric :phone_owner
    assert_member :type, ["sip", "mobile", "land"]
  end
    
  def create
    if self.is_sip?
      @cv = Cloudvox.new
      
      # generate random alpha password
      self.cv_password = (0...8).map{ ('a'..'z').to_a[rand(26)] }.join + "-" + rand(9).to_s
    
      begin
        @json_response = @cv.create_sip_account(self.exten.to_s, self.phone_owner + "" + self.exten.to_s, self.cv_password)
        self.cv_id ||= @json_response["endpoint"]["id"]
        logger.info("Creating SIP phone with cloudvox id " + self.cv_id.to_s)
      rescue Exception => e
        logger.error("SIP phone creation failed.")
        logger.error("json response is " + @json_response.to_s)
        logger.error("Exception in Phone.create: " + e.message)
        raise CloudvoxSipError, "SIP phone creation failed for user " + phone_owner, caller
      end
    end
    
    # if we got an ID back from cloudvox, save the other info to the phone object
    if self.cv_id
      self.cv_extension = @json_response["endpoint"]["extension"]
      self.cv_username =  @json_response["endpoint"]["full_username"]
      self.cv_domain =    @json_response["endpoint"]["hostname"]
      super
    else
      super
    end
  end
  
  def delete
    if self.is_sip?
      @cv = Cloudvox.new
      
      begin
        @json_response = @cv.delete_sip_account(self.cv_id)
        logger.info("Deleting SIP phone with cloudvox id " + self.cv_id.to_s)
      rescue Exception => e
        logger.error("SIP phone deletion failed for Cloudvox SIP phone ID " + cv_id.to_s)
        logger.error("Exception in Phone.delete: " + e.message)
        raise CloudvoxSipError, "SIP phone deletion failed for Cloudvox SIP phone ID " + cv_id.to_s, caller
      else
        super
      end
    else
      super
    end
  end
  
  def verify!
    self.verified = true
    self.save if self.valid?
  end
  
  def unverify!
    self.verified = nil
    self.save if self.valid?
  end
  
  def verified?
    self.verified
  end
  
  def verifyable?
    case self.type
      when "sip" then false
      when "land" then true
      when "mobile" then true
    end
  end
  
  def verify_with_code(code)
    if code && code == self.verification_code
      self.verify!
    end
  end
  
  def send_verification_code
    return nil unless self.verifyable?
    @cv = Cloudvox.new
    
    self.verification_code = case self.type
      when "mobile" then @cv.send_code_to_mobile(self.exten)
      when "land" then @cv.send_code_to_land(self.exten)
      when "sip" then nil
    end
    
    self.save if self.valid?
  end
  
  def is_sip?
    self.type == "sip"
  end
  
  def is_land?
    self.type == "land"
  end
  
  def is_mobile?
    self.type == "mobile"
  end
  
  def to_s
    self.name.to_s
  end
  
  def username
    User.username_for(self.phone_owner)
  end
  
  protected
    def assign_sip_exten
      if self.is_sip? && ! self.exten
        @sip_phones = Phone.find(:type => "sip")
        self.exten = 1
        @sip_phones.each do |sip_phone|
          if self.exten <= (sip_phone.exten.to_i)
            self.exten = (sip_phone.exten.to_i) + 1
          end
        end
      end
    end
  
end

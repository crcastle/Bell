# represents an endpoint on the system
# could be either a SIP phone or PSTN phone
class Phone < Ohm::Model
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
  
  def validate
    assert_present :type
    assert_present :exten
    assert_present :name
    assert_numeric :phone_owner
  end
  
  def create
    if self.is_sip?
      @cv = Cloudvox.new
      
      # generate random alpha password
      self.cv_password = (0...8).map{ ('a'..'z').to_a[rand(26)] }.join + "-" + rand(9).to_s
    
      begin
        @json_response = @cv.create_sip_account(self.exten, self.phone_owner + "" + self.exten, self.cv_password)
        self.cv_id ||= @json_response["endpoint"]["id"]
        logger.info("Creating SIP phone with cloudvox id " + self.cv_id.to_s)
      rescue Exception => e
        logger.error("SIP phone creation failed.")
        logger.error("json response is " + @json_response.to_s)
        logger.error("Exception in Phone.create: " + e.message)
        raise CloudvoxSipError, "SIP phone creation failed for user " + phone_owner, caller
      end
    end
    
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
    if self.valid?
      self.save
    else
      false
    end
  end
  
  def verified?
    verified ? true : false
  end
  
  def is_sip?
    type == "sip"
  end
  
  def is_land?
    type == "land"
  end
  
  def is_mobile?
    type == "mobile"
  end
  
  def to_s
    name.to_s
  end
  
end

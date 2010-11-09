# represents an endpoint on the system
# could be either a SIP phone or PSTN phone
class Phone < Ohm::Model
  attribute :type # "sip" or "pstn"
  attribute :exten # SIP extension or PSTN phone number
  attribute :name # user-supplied name for this phone
  attribute :phone_owner # user id of the phone owner
  
  index :exten
  index :phone_owner
  
  def validate
    assert_present :type
    assert_present :exten
    assert_present :name
    assert_numeric :phone_owner
  end
  
  def to_s
    name.to_s
  end
  
end

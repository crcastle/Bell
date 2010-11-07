# represents an endpoint on the system
# could be either a SIP phone or PSTN phone
class Phone < Ohm::Model
  attrib :type # "sip" or "pstn"
  attrib :exten # SIP extension or PSTN phone number
  attrib :name # user-supplied name for this phone
  attrib :phone_owner # user id of the phone owner
  
  index :exten
  index :phone_owner
  
  def validate
    assert_present :type
    assert_present :exten
    assert_present :name
    assert_numeric :phone_owner
  end
  
end

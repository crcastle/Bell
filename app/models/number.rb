class Number < Ohm::Model
  attribute :did
  attribute :did_owner
  attribute :state
  attribute :area_code
  
  index :did
  index :did_owner
  index :state
  index :area_code
  
  def validate
    assert_unique :did
  end

  def set_owner(owner)
    write_local(:did_owner, owner)
  end
  
  def get_owner
    did_owner
  end

  def to_s
    did.to_s
  end
  
  # returns false if this Number is assigned a did_owner
  def available?
    did_owner.nil? ? true : (did_owner == "" ? true : false)
  end
  
  def username
    User.username_for(self.did_owner)
  end
end

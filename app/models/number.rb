class Number < Ohm::Model
  attribute :did
  attribute :did_owner
  
  index :did
  index :did_owner
  
  def validate
    assert_unique :did
  end

end

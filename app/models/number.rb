class Number < Ohm::Model
  attrib :did
  attrib :did_owner
  
  index :did
  index :did_owner
  
  def validate
    assert_unique :did
  end

end

class Voicemail < Ohm::Model
  attribute :caller_id
  attribute :called_id
  attribute :url
  attribute :datetime
  attribute :for_user
  attribute :is_read
  
  index :called_id
  index :datetime
  index :for_user
  
  def validate
    assert_present :caller_id
    assert_present :called_id
    assert_present :url
    assert_present :is_read
    assert_numeric :for_user
  end
  
  # format datetime
  def create
    self.datetime ||= Time.now.strftime("%Y-%m-%d %H:%M:%S")
    super
  end
  
  # convert the url to the proper form if it's not empty
  # and is not already of the proper form.
  def url=(value)
    value = "http://#{value}" unless value.empty? || value =~ %r{^http://} || value =~ %r{^https://}
    write_local(:url, value)
  end
end

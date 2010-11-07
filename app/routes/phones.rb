class Main
  # show the phones for a user
  get "/phones" do
    haml :"phones/list"
  end
  
  # show the details for a phone
  get "/phones/:id" do
    @phone = Phone[:params[:id]]
    
    @owner = User[@phone.phone_owner]
    @name = @phone.name
    @type = @phone.type
    @exten = @phone.exten
    
    haml :"phones/id"
  end
  
  # add a new phone to an account
  post "/phones" do
    
  end
  
  module Helpers
    def list(name, type, exten)
      partial(:"phone/list", :name => name, :type => type, :exten => exten)
    end
  end
  
  include Helpers
end
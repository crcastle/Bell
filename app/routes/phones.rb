class Main
  # show the phones for a user
  get "/phones" do
    @owner = User[session[:user]]
    @owner_name = @owner.username
    @phones = @owner.phones
    
    haml :"phones"
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
    def list(phones, message = "You don't have any phones! Set one up?")
      partial(:"phones/list", :phones => phones, :message => message)
    end
  end
  
  include Helpers
end
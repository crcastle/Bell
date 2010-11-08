class Main
  # show the phones for a user
  get "/phones" do
    require_login
    
    @owner = User[session[:user]]
    @owner_name = @owner.username
    @phones = @owner.phones
    
    haml :"phones"
  end
  
  # add a new phone to an account
  post "/phones" do
    accept_login_or_signup
    
    @phone = Phone.new(params[:phone])
    @phone.phone_owner = current_user.id if current_user

    if @phone.valid?
      @phone.create
      session[:notice] = "Phone has been registered."
      redirect "/phones"
    else
      haml :"phones/new"
    end
  end
  
  get "/phones/new" do
    require_login
    
    @phone = Phone.new
    haml :"phones/new"
  end
  
  # show the details for a phone
  get "/phones/:id" do
    require_login
    
    @phone = Phone[:params[:id]]
    
    @owner = User[@phone.phone_owner]
    @name = @phone.name
    @type = @phone.type
    @exten = @phone.exten
    
    haml :"phones/id"
  end
  
  module Helpers
    def list(phones, message = "You don't have any phones! Set one up?")
      partial(:"phones/list", :phones => phones, :message => message)
    end
  end
  
  include Helpers
end
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
    
    @phone = Phone[params[:id]]
    
    # if user trying to view a phone he doesn't own
    # so just redirect to phones listing
    if current_user.id != @phone.phone_owner
      session[:error] = "Sorry, you can't edit a phone you don't own."
      redirect "/phones"
    end
    
    @owner = User[@phone.phone_owner]
    @name = @phone.name
    @type = @phone.type
    @exten = @phone.exten
    
    haml :"phones/id"
  end
  
  # update a phone
  post "/phones/:id" do
    accept_login_or_signup
    
    @phone = Phone[params[:id]]
    
    # if user trying to edit a phone he doesn't own
    # so just redirect to phones listing
    if @phone.phone_owner != current_user.id
      session[:error] = "Sorry, you can't edit a a phone you don't own."
      redirect "/phones"
    end
    
    @phone.name = params[:phone][:name]
    @phone.exten = params[:phone][:exten]
    @phone.type = params[:phone][:type]
    
    if @phone.valid?
      @phone.save
      session[:notice] = "Phone has been modified."
      redirect "/phones"
    else
      haml :"phones/id"
    end
  end
  
  module Helpers
    def list_phones(phones, message = "You don't have any phones! Set one up?")
      partial(:"phones/list", :phones => phones, :message => message)
    end
    
    def link_to_phone(phone)
      capture_haml do
        haml_tag(:a, phone, :href => "/phones/#{phone.id}", :title => phone)
      end
    end
  end
  
  include Helpers
end
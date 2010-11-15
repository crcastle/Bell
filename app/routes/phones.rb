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
  
  delete "/phones/:id" do
    accept_login_or_signup
    
    @phone = Phone[params[:id]]
    
    # if user trying to edit a phone he doesn't own
    # so just redirect to phones listing
    if @phone.phone_owner != current_user.id
      session[:error] = "Sorry, you can't delete a a phone you don't own."
      redirect "/phones"
    end    
    
    @phone.delete
    session[:notice] = "Phone has been deleted."
    redirect "/phones"
  end
  
  get "/phones/:id/verify" do
    require_login
    
    @phone = Phone[params[:id]]
    
    if @phone.is_sip?
      session[:notice] = "SIP phones do not need to be verified."
      redirect "/phones/" + params[:id].to_s
    elsif @phone.is_mobile?
      # ask user to enter 4-digit verification code
      # explain that an SMS message will be sent with a 4 digit number
      # ask the user to click the button (post) to send a message with verification code
      # clicking the button clears any past verification code and creates a new one
    elsif @phone.is_land?
      # ask user to enter 4-digit verification code
      # explain that user's phone will ring and say a 4-digit number
      # ask the user to click the button (post) to make the call with the verification code
      # clicking the button clears any past verification code and creates a new one
    else
      redirect "/phones/" + params[:id].to_s
    end
  end
  
  post "/phones/:id/verify" do
    accept_login_or_signup
    
    @phone = Phone[params[:id]]
    
    if @phone.is_sip?
      session[:notice] = "SIP phones do not need to be verified."
      redirect "/phones/" + params[:id].to_s
    elsif @phone.is_mobile?
      # send SMS message
    elsif @phone.is_land?
      # verify a landline phone with a call
    else
      redirect "/phones/" + params[:id].to_s
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
    
    def link_to_verify(text)
      cature_haml do
        haml_tag(:a, text, :href => "/phones/#{phone.id}/verify", :title => text)
      end
    end
  end
  
  include Helpers
end
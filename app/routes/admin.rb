class Main
  get '/admin/?' do
    require_admin
    
    haml :"admin"
  end
  
  # list all users
  get '/admin/users/?' do
    require_admin
    
    @users = User.all
    
    haml :"admin/users"
  end
  
  # create new user
  post '/admin/users/?' do
    require_admin
  end
  
  # display user info
  get '/admin/users/:id/?' do
    require_admin
    
    @user = User[params[:id]]
    
    haml :"admin/users/id"
  end
  
  # update user info
  put '/admin/users/:id/?' do
    require_admin
    
    @user = User[params[:id]]
    
    if @user.update(params[:user])
      session[:notice] = "User updated."
      redirect "/admin/users"
    else
      session[:error] = "Error updating user."
      haml :"admin/users/id"
    end
  end
  
  # delete user
  delete '/admin/users/:id/?' do
    require_admin
    
    User[params[:id]].delete
    
    session[:notice] = "User deleted."
    redirect "/admin/users"
  end
  
  # list a user's phones
  get '/admin/users/:id/phones/?' do
    require_admin
    
    @phones = Phone.find(:phone_owner => params[:id])
    
    # display som haml
  end
  
  # list a user's numbers
  get '/admin/users/:id/numbers/?' do
    require_admin
    
    @numbers = Number.find(:did_owner => params[:id])
    
    # display some haml
  end
  
  # list all phones
  get '/admin/phones/?' do
    require_admin
    
    @phone = Phone.new
    @phones = Phone.all
    
    haml :"admin/phones"
  end
  
  # show phone details
  get '/admin/phones/:id/?' do
    require_admin
    
    @phone = Phone[params[:id]]
    
    haml :"/admin/phones/id"
  end
  
  # create new phone
  post '/admin/phones/?' do
    require_admin
    
    # create phones set in case of error so that
    # /admin/phones can be created again
    @phones = Phone.all
    
    @phone = Phone.new(params[:phone])
    if @phone.valid?
      @phone.create
      session[:notice] = "New phone created."
      redirect "/admin/phones"
    else
      session[:error] = "Error creating new phone."
      haml :"/admin/phones"
    end
  end
  
  # update phone
  put '/admin/phones/:id/?' do
    require_admin
    
    @phone = Phone[params[:id]]
    
    if @phone.update( :name => params[:phone][:name],
                      :exten => params[:phone][:exten],
                      :type => params[:phone][:type],
                      :phone_owner => params[:phone][:phone_owner])
      session[:notice] = "Phone has been modified."
      redirect "/admin/phones"
    else
      haml :"admin/phones/id"
    end
  end
  
  # verify or unverify phone
  put '/admin/phones/:id/verify/?' do
    require_admin
    
    @phone = Phone[params[:id]]
    if @phone.verified?
      @phone.unverify!
      session[:notice] = "Phone successfully UN-verified."
      haml :"/admin/phones/id"
    else
      @phone.verify!
      session[:notice] = "Phone successfully verified."
      haml :"/admin/phones/id"
    end
  end
  
  # delete phone
  delete '/admin/phones/:id/?' do
    require_admin
    
    Phone[params[:id]].delete
    
    session[:notice] = "Phone deleted."
    redirect '/admin/phones'
  end
  
  # list all numbers
  get '/admin/numbers/?' do
    require_admin
    
    @number = Number.new
    @numbers = Number.all
    
    haml :"admin/numbers"
  end
  
  # create new number
  post '/admin/numbers/?' do
    require_admin
    
    @number = Number.new(params[:number])
    if @number.valid?
      @number.create
      session[:notice] = "New phone number created."
      redirect "/admin/numbers"
    else
      session[:error] = "Error creating new number."
      haml :"/admin/numbers"
    end
  end
  
  # show number details
  get '/admin/numbers/:id/?' do
    require_admin
    
    @number = Number[params[:id]]
    @did = @number.did
    @state = @number.state
    @id = params[:id]
    
    haml :"admin/numbers/id"
  end
  
  # update number
  put '/admin/numbers/:id/?' do
    require_admin
    
    @number = Number[params[:id]]
    
    @number.did =       params[:number][:did]
    @number.did_owner = params[:number][:did_owner]
    @number.state     = params[:number][:state]
    @number.area_code = params[:number][:area_code]
    
    if @number.valid?
      @number.save
      session[:notice] = "Number updated."
      redirect '/admin/numbers'
    else
      session[:error] = "Number update failed."
      redirect request.url
    end
  end
  
  # delete number
  delete '/admin/numbers/:id/?' do
    require_admin
    
    Number[params[:id]].delete
    
    session[:notice] = "Number deleted."
    redirect '/admin/numbers'
  end
  
  helpers do
    
  end
end
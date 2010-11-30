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
  
  get '/admin/users/:id/?' do
    require_admin
  
  end
  
  get '/admin/users/:id/phones/?' do
    require_admin
  
  end
  
  get '/admin/users/:id/numbers/?' do
    require_admin
  
  end
  
  # list all phones
  get '/admin/phones/?' do
    require_admin
    
    @phones = Phone.all
    
    haml :"admin/phones"
  end
  
  get '/admin/phones/:id/?' do
    require_admin
  
  end
  
  # list all numbers
  get '/admin/numbers/?' do
    require_admin
    
    @numbers = Number.all
    
    haml :"admin/numbers"
  end
  
  # create new number
  post '/admin/numbers/?' do
    require_admin
    
    
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
  
  delete '/admin/numbers/:id/?' do
    require_admin
    
    Number[id].delete
    
    session[:notice] = "Number deleted."
    redirect '/admin/numbers'
  end
  
  helpers do
    
  end
end
# adapted from https://github.com/monkrb/reddit-clone/tree/master/app/routes/
class Main
  #helpers Pagination::Helpers
  
  get "/login/?" do
    haml :"login"
  end
  
  post "/login/?" do
    begin
      authenticate(params)
      redirect_to_stored
    rescue Exception => e
      logger.error("Exception in /login: " + e.message)
      session[:error] = "We are sorry: the information supplied is not valid."
      haml :"login"
    end
  end
  
  get "/logout/?" do
    session[:user] = nil
    redirect "/"
  end
  
  get "/signup/?" do
    @user = User.new
    
    haml :"signup"
  end
  
  post "/signup/?" do
    @user = signup(params[:user])
    
    begin
      logger.info("Checking if username already exists.")
      user_id = @user.id
      logger.info("User creation successful. Redirecting to homepage.")
      redirect "/", 303
    rescue
      logger.info("Username already exists. Displaying signup page with error.")
      haml :"signup"
    end    
  end
  
  helpers do
    def require_login
      if session[:user]
        return true
      else
        session[:return_to] = request.fullpath
        session[:error] = "You need to login first!"
        redirect "/login"
        return false
      end
    end
    
    def authenticate(params)
      session[:user] = User.authenticate(params[:username], params[:password]).id
      logger.debug("authenticate: session[:user] = " + session[:user])
    end
    
    def signup(params)
      user = User.new(params)
      
      if user.create
        logger.debug("user.create true")
        session[:user] = user.id
      else
        logger.debug("user.create false")
      end
      
      user
    end
    
    def authenticate_or_signup(params)
      if params.delete("existing") == "1"
        authenticate(params)
      else
        signup(params)
      end
    end
    
    def current_user
      @current_user ||= User[session[:user]] if session[:user]
    end
    
    def require_admin
      halt 404 unless logged_in? && current_user.admin?
    end
    
    def redirect_to_stored
      if return_to = session[:return_to]
        session[:return_to] = nil
        redirect return_to
      else
        redirect "/"
      end
    end
    
    def logged_in?
      !! current_user
    end
    
    def ensure_current_account(username)
      halt 404 unless current_user && current_user.username == username
    end
    
    def accept_login_or_signup
      if params[:session]
        begin
          authenticate_or_signup(params[:session])
        rescue User::WrongUsername, User::WrongPassword
        end
      end
    end
  end
end

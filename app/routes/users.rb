# adapted from https://github.com/monkrb/reddit-clone/tree/master/app/routes/
class Main
  get "/users/:username/?" do
    @user = User.find(:username, params[:username]).first
    
    haml :"users/username"
  end
end

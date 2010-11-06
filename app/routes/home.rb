# adapted from https://github.com/monkrb/reddit-clone/tree/master/app/routes/
class Main
  get "/" do
    
    haml :"home"
  end
end
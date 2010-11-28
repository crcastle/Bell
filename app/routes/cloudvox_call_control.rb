class Main
  get "/cv/verify_land" do
    content_type :json
    
    status = request.cookies["status"]
    status ||= "start"
    
    attempts = request.cookies["attempts"]
    attmepts ||= 0
    attempts = attempts.to_i
    attempts += 1
    set_cookie("attempts",attempts)
    
    
    # if it's the first request
    if status == "start"
      # hangup if we've already tried 2 times
      return hangup.to_json if attempts > 2
      
      # update status cookie
      status = "verify"
      set_cookie("status",status)
      
      # define output
      @phrase = "Hello, this is the Bell Phone app. Please press 1 to hear this phone's verification code."
      @max_digits = "1"
      @timeout = "2"
      @callback_url = "http://localhost/cv/verify_land"
      response = [{:name => "Speak", :phrase => @phrase},{:name => "GetDigits", :max => @max_digits, :timeout => @timeout, :url => @callback_url}].to_json
    end
    
    if status == "verify"
      # if user pressed 1, play the verification code twice.
      if params[:result] == "1"
        @random_4 = rand(9999).to_s
        @phrase = "This phone's verification code is " + @radmon_4 + ".  Again, this phone's verification code is " + @random_4 + "."
        response = [{:name => "Speak", :phrase => @phrase},hangup].to_json
      else # if the user didn't press 1, set cookie to 0 and redirect to url
        cookie = "start"
        set_cookie("verify_land", cookie)
        redirect "/cv/verify_land"
      end      
    end
  end
  
  helpers do
    def hangup
      {:name => "Hangup"}
    end
  end
end
class Main
  get "/cv/verify_land" do
    content_type :json
    
    @random_4 = params[:random_4]
    response.set_cookie("code",@random_4)
    
    @attempts = request.cookies["attempts"]
    @attmepts ||= 0
    @attempts = @attempts.to_i
    @attempts += 1
    response.set_cookie("attempts",@attempts)
    
    # hangup if we've already tried 2 times
    return hangup.to_json if @attempts > 2
    
    # define output
    @phrase = "Please press the 1 key to hear your phone's verification code."
    @max_digits = "1"
    @timeout = "2"
    @callback_url = "http://bell.heroku.com/cv/verify_land"
    @json_output = [{:name => "Speak", :phrase => @phrase},{:name => "GetDigits", :max => @max_digits, :timeout => @timeout, :url => @callback_url}].to_json
  end
  
  post "/cv/verify_land" do
    @random_4 = request.cookies["code"]
    
    if params[:result] == "1"
      @phrase = "This phones verification code is " + @random_4 + ".  Again.  This phone's verification code is " + @random_4 + "."
      @json_output = [{:name => "Speak", :phrase => @phrase},hangup].to_json
    else # if the user didn't press 1, set cookie to start and redirect to url
      response.set_cookie("status","start")
      redirect "/cv/verify_land"
    end
  end
  
  helpers do
    def hangup
      {:name => "Hangup"}
    end
  end
end
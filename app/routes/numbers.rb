class Main
  # show the numbers for a user
  get "/numbers" do
    require_login
    
    @owner = User[session[:user]]
    @owner_name = @owner.username
    @numbers = @owner.numbers
    haml :"numbers"
  end
  
  # add a new number to an account
  post "/numbers" do
    accept_login_or_signup
    
    @number = Number.find(:did => params[:number][:did]).first
    @number.set_owner(current_user.id) if current_user
    
    if @number.valid?
      @number.save      
      session[:notice] = "You now own that number!"
      redirect "/numbers"
    else
      haml :"numbers/new"
    end
  end
  
  get "/numbers/add" do
    require_login
    redirect "/" unless current_user.id == "1"
    
    @number = Number.new
    @numbers = Number.all
    haml :"numbers/add"
  end
  
  post "/numbers/add" do
    accept_login_or_signup  
    redirect "/" unless current_user.id == "1"
    
    @number = Number.new(params[:number])
    if @number.valid?
      @number.create
      session[:notice] = "New phone number added."
      redirect "/numbers/add"
    else
      haml :"/numbers/add"
    end
  end

  get "/numbers/new" do
    require_login
    
    @number = Number.new
    @numbers = Number.find(:did_owner => nil)
    haml :"numbers/new"
  end
  
  # show the details for a phone
  get "/numbers/:id" do
    require_login
    
    @number = Number[params[:id]]
    
    # if user trying to view a number he doesn't own
    # so just redirect to numbers listing
    if current_user.id != @number.did_owner
      session[:error] = "Sorry, you can't edit a number you don't own."
      redirect "/numbers"
    end
    
    #@owner = User[@number.did_owner]    
    @did = @number.did
    @state = @number.state
    @id = params[:id]

    haml :"numbers/id"
  end
  
  post "/numbers/:id" do
    accept_login_or_signup
    
    @number = Number[params[:id]]
    
    # if user trying to edit a phone he doesn't own
    # so just redirect to phones listing
    if @number.did_owner != current_user.id
      session[:error] = "Sorry, you can't edit a a number you don't own."
      redirect "/numbers"
    end
    
    # set owner as nil to make this number available
    @number.set_owner(nil) if @number.get_owner == current_user.id
    
    if @number.valid?
      @number.save      
      session[:notice] = "Number deleted from your account."
      redirect "/numbers"
    else
      @number.set_owner(current_user.id) if current_user
      #@owner = User[@number.did_owner]
      @did = @number.did
      @state = @number.state
      @id = params[:id]
      
      haml :"numbers/id"
    end
  end
  
  module Helpers
    def list_numbers(numbers, message = "You don't have any numbers! Set one up?")
      partial(:"numbers/list", :numbers => numbers, :message => message)
    end
    
    def link_to_number(number)
      capture_haml do
        haml_tag(:a, format_number(number), :href => "/numbers/#{number.id}", :title => number)
      end
    end
    
    def show_availability(number)
      number.available? ? "Available" : "Taken"
    end
    
    def number_option(number)
      capture_haml do
        haml_tag(:option, number, :value => number)
      end
    end
  end
  
  include Helpers
end

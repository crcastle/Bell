class Main
  helpers WillPaginate::ViewHelpers::Base
  
  get '/history' do
    require_login
    redirect '/history/1'
  end
  
  get '/history/:page' do
    # display call history for this user
    # paginate
    # fileter by date
    # filter by incoming, outgoing
    # filter by phone
    # filter by number
    # filter by type
    # download
    
    require_login
    
    # fetch call history as JSON
    @owner = User[session[:user]]
    @cdr = @owner.get_call_history
    
    @cdr_new = []
    @cdr.each do |record|
      @cdr_new.push(record["call_detail_record"])
    end
    
    @current_page = params[:page].to_i
    @per_page = 10

    #@page_results = @cdr_new.paginate(:current_page => @current_page, :per_page => @per_page)

    @page_results = WillPaginate::Collection.create(@current_page, @per_page, @cdr_new.length) do |pager|
      start = (@current_page-1)*@per_page # assuming current_page is 1 based.
      pager.replace(@cdr_new[start, @per_page])
    end

    haml :"history"
  end
end

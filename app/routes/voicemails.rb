class Main
  # list voicemails
  get "/voicemails" do
    # list all voicemails in DB for current_user
  end
  
  # create voicemail
  post "/voicemails" do
    # create a voicemail in DB for user determined by number called
    # mark new voicemail as "new"
  end  

  # play voicemail
  get "/voicemails/:id" do
    # check if voicemail :id belongs to current_user
    # show voicemail details with option to play and delete
  end
  
  # play voicemail
  get "/voicemails/:id/play"
    # check if voicemail :id belongs to current_user
    # play voicemail :id
    # mark voicemail :id as "not new"
  end
  
  # delete voicemail
  post "/voicemails/:id" do
    # check if voicemail :id belongs to current_user
    # delete voicemail from voicemail storage location
    # delete voicemail from DB
  end
end

require 'yaml'
require 'rest_client'
require 'json'

class Cloudvox
  def initialize
    @cv_config = YAML.load_file 'cloudvox_account.yml'
  
      #cloudvox_account.yml format
      #
      #domain: <username>
      #user: <email@address.com>
      #password: <yourCVpassword>
  
    @cloudvox_api = RestClient::Resource.new("https://#{@cv_config['domain']}.cloudvox.com", :user => @cv_config['user'], :password => @cv_config['password'])
  end

  def list_sip_accounts
    @cloudvox_api['/phones.json'].get
  end

  # create a Cloudvox sip account returning a Hash with account info
  # extension: choose a SIP extension
  # username: choose a SIP username
  # password: choose a SIP password
  def create_sip_account(extension, username, password)
    #password must be > 6 characters per Cloudvox
    JSON.parse((@cloudvox_api['/phones.json'].post :endpoint => {:extension => extension, :username => username, :password => password}).body)
  end

  # delete a Cloudvox sip account
  # id: Cloudvox sip id
  # returns nothing
  # TODO: currently there is no way to know whether this is successful or not
  def delete_sip_account(id)
    @cloudvox_api["/phones/#{id}.json"].delete
  end
  
  # create a Cloudvox app
  def create_app(name, url)
    JSON.parse((@cloudvox_api["/application/create.json"].post :call_flow => {:name => name}, :agi => {:url => url}).body)
  end
  
  # Call number and connect to Cloudvox app 805
  # pass random up-to-4-digit number
  # and return it upon call success
  def send_code_to_land(number)
    # generate random 4 digit number
    @random_4 = rand(9999).to_s
    logger.info("random digits generated for land: " + @random_4)
    
    # call a landline number
    # TODO: update the "805" in the URL to be dynamic
    begin
      @cloudvox_api["/api/v1/http/applications/872/dial"].post :destination => number, :random_4 => @random_4
    rescue Exception => e
      logger.error("Exception from 'send_code_to_land': " + e.message)
      return nil
    else
      return @random_4
    end
  end
  
  def send_code_to_mobile(number)
    # generate random 4 digit number
    @random_4 = rand(9999).to_s
    logger.info("random digits generated for mobile: " + @random_4)
    
    # send a SMS with only 4 digits to number
    # TODO: update the "805" in the URL to be dynamic
    begin
      @cloudvox_api["/api/v1/applications/805/sms"].post :to => number, :from => "14252243400", :message => @random_4
    rescue Exception => e
      logger.error("Exception from 'send_code_to_mobile': " + e.message)
      return nil
    else
      return @random_4
    end
  end
  
  # returns a ruby object with call history
  def get_call_history(app_id)
    JSON.parse((@cloudvox_api["/applications/" + app_id + "/call_detail_records.json"].get).body)
  end
end
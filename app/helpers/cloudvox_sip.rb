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

  def create_sip_account(extension, username, password)
    #password must be > 6 characters 
    JSON.parse((@cloudvox_api['/phones.json'].post :endpoint => {:extension => extension, :username => username, :password => password}).body)

  end

  def delete_sip_account(id)
    @cloudvox_api["/phones/#{id}.json"].delete
  end
  
  def create_app(name, url)
    @cloudvox_api["/application/create.json"].post
  end
end
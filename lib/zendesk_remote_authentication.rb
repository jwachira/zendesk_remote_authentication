require 'digest/md5'
require 'active_support'

module Zendesk
  class RemoteAuthentication
    class << self
      attr_writer :auth_url, :token
      
      def token
        raise ArgumentError.new('Zendesk Token has not been set yet. Set with Zendesk::RemoteAuthentication.token = <token>') unless @token
        @token
      end
  
      def auth_url
        raise ArgumentError.new('Zendesk authentication url has not been set yet. Set with Zendesk::RemoteAuthentication.auth_url = <token>') unless @auth_url
        @auth_url
      end
      
    end

  end
end

module RemoteAuthenticationHelper
   #you can either pass username and email or a user object which contains email and username attributes
   def zendesk_remote_authentication_url(params)
     params = params.is_a?(Hash) ? params : convert_user_to_a_hash(params)

     #TODO: Need a class to validate the params
     raise ArgumentError.new("You must provide name and email address") unless (params[:name] && params[:email])

     #add timestamp if none is passed in the params  
     params[:timestamp] = Time.now.utc.to_i unless params[:timestamp]

     params[:hash] = params[:external_id] ? generate_authentication_hash(Zendesk::RemoteAuthentication.token, params) : ''

     "#{Zendesk::RemoteAuthentication.auth_url}?#{params.to_query}"
  end
  
  def convert_user_to_a_hash(user)
    params = {}
    params[:name]  = "#{user.first_name} #{user.last_name}"
    params[:email] = user.email
    params[:external_id] = user.id
    return params
  end
  
  def generate_authentication_hash(token, params)
    Digest::MD5.hexdigest(params[:name] + params[:email] + params[:external_id] + token + params[:timestamp])
  end
  
end
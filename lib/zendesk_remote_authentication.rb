require 'digest/md5'
require 'active_support'

module Zendesk
  class RemoteAuthentication
    class << self
      attr_writer :auth_url, :token
      
      def token
        raise ArgumentError.new('Set your Zendesk token with. Zendesk::RemoteAuthentication.token = <token>') unless @token
        @token
      end
  
      def auth_url
        raise ArgumentError.new('Set your Zendesk authentication url with, Zendesk::RemoteAuthentication.auth_url = <token>') unless @auth_url
        @auth_url
      end
      
    end

  end
end

module RemoteAuthenticationHelper

   def zendesk_remote_authentication_url(params)
      raise ArgumentError.new("You must provide name and email address") unless (params[:name] && params[:email])
      
      token       = Zendesk::RemoteAuthentication.token
      timestamp   = params[:timestamp] || Time.now.to_i.to_s
      name        = params[:name]
      email       = params[:email].force_utf8
      external_id = params[:external_id]
      hash        = Digest::MD5.hexdigest(name + email + external_id + token + now)
      back        = params[:return_to]

      auth_params = [
        '?name='      + CGI.escape(name),
        '&email='     + CGI.escape(email),
        '&timestamp=' + now,
        '&hash='      + hash,
        '&return_to=' + back
      ].join.force_utf8

      Zendesk::RemoteAuthentication.auth_url + auth_params
    
  end

end

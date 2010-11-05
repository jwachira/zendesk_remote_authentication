require 'helper'

class TestZendeskRemoteAuthentication < Test::Unit::TestCase
  
  context "Ioffer to Zendesk Remote Authentication" do
    setup do
      Zendesk::RemoteAuthentication.token = Zendesk::RemoteAuthentication.auth_url = nil
    end
    
    should "raise an exception if a token is not set" do
      assert_raise ArgumentError do
        Zendesk::RemoteAuthentication.token
      end
    end
    
    should "raise an exception if authentication url is not set" do
      assert_raise ArgumentError do
       Zendesk::RemoteAuthentication.auth_url
      end
    end
    
    should "return a token without an exception" do
      token = Zendesk::RemoteAuthentication.token = "bang"
      assert token == "bang"
    end
    
    should "return authentication url without an exception" do
      authentication_url = Zendesk::RemoteAuthentication.auth_url = "ding.ioffer.com"
      assert authentication_url == "ding.ioffer.com"
    end
  end
  
  context "Authentication Url Generator" do
    setup do
      @object = Object.new
      @object.send(:extend, RemoteAuthenticationHelper)
      @token = Zendesk::RemoteAuthentication.token = 'ujLcNkJkrr5ezvppUHI2CdtJPne5qszX2Twlfm397ear6pm5'
      @auth_url = Zendesk::RemoteAuthentication.auth_url = 'https://www.ioffer.com/login?request_uri=http://help.ioffer.com'
      @params = { :email => 'james@ioffer.com', :name => 'James'}
    end
    
    context "Required Attributes" do 
      should 'raise an argument error if the name is not provided' do
        assert_raise ArgumentError do
          @params.delete(:name)
          @object.zendesk_remote_authentication_url(@params)
        end
      end
    
      should 'raise an argument error if an email is not provided' do
        assert_raise ArgumentError do
          @params.delete(:email)
          @object.zendesk_remote_authentication_url(@params)
        end
      end
      
      # should "generate remote external authentication url" do
      #   raise @object.zendesk_remote_authentication_url(@params).inspect
      # end
    end
  end
  
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ApplicationController do
  
  # ----------------- SESSION TIMEOUT -----------------------
  describe ApplicationController, "with session timeout features" do
    before(:all) do
      sorcery_reload!([:session_timeout])
      sorcery_controller_property_set(:session_timeout,0.5)
      create_new_user
    end
    
    it "should not reset session before session timeout" do
      login_user
      get :test_should_be_logged_in
      session[:user_id].should_not be_nil
      response.should be_a_success
    end
    
    it "should reset session after session timeout" do
      login_user
      sleep 0.6
      get :test_should_be_logged_in
      session[:user_id].should be_nil
      response.should be_a_redirect
    end
    
    it "with 'session_timeout_from_last_action' should not logout if there was activity" do
      sorcery_controller_property_set(:session_timeout_from_last_action, true)
      login_user
      sleep 0.3
      get :test_should_be_logged_in
      session[:user_id].should_not be_nil
      sleep 0.3
      get :test_should_be_logged_in
      session[:user_id].should_not be_nil
      response.should be_a_success
    end
    
    it "with 'session_timeout_from_last_action' should logout if there was no activity" do
      sorcery_controller_property_set(:session_timeout_from_last_action, true)
      login_user
      sleep 0.6
      get :test_should_be_logged_in
      session[:user_id].should be_nil
      response.should be_a_redirect
    end
    
  end
end
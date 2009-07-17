require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "with a anonymous user visiting" do
  describe "#index" do
    integrate_views

    def do_request
      get :index
    end
    
    it_should_behave_like "login_required"
  end

  describe "#quickbooks" do
    integrate_views
  
    def do_request
      get :quickbooks
    end
    
    it_should_behave_like "login_required"
  end

end

describe SystemReportsController, "with an unauthorized user visiting" do
  describe "#index" do
    integrate_views

    def do_request
      get :index
    end

    before(:each) do
      logged_in_as_user
    end
    
    it_should_behave_like "denied_access"
  end

  describe "#quickbooks" do
    integrate_views
  
    def do_request
      get :quickbooks
    end
    
    before(:each) do
      logged_in_as_user
      @current_user.stub!(:allowed_to?).and_return(false)
    end

    it_should_behave_like "denied_access"
  end

end

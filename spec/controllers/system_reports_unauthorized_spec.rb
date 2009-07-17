require File.dirname(__FILE__) + '/../spec_helper'

describe "login_required", :shared => true do
  it 'should redirect' do
    do_request
    response.should be_redirect
  end
  
  it 'should redirect to the login page' do
    do_request
    response.should redirect_to(:controller => 'account', :action => 'login', :back_url => controller.url_for(params))
  end
  
end

describe "denied_access", :shared => true do
  it 'should not be successful' do
    do_request
    response.should_not be_success
  end
  
  it 'should return a 403 status code' do
    do_request
    response.code.should eql("403")
  end
  
  it 'should display the standard unauthorized page' do
    do_request
    response.should render_template('common/403')
  end

end


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

require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "#index" do
  integrate_views

  before(:each) do
    logged_in_as_user
    @current_user.stub!(:allowed_to?).and_return(false)
  end
  
  it 'should be successful' do
    get :index
    response.should be_success
  end

  it 'should render the index template' do
    get :index
    response.should render_template('index')
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

end

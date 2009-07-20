require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "with a anonymous user visiting" do
  describe "#completion_count" do
    integrate_views
  
    def do_request
      get :completion_count
    end
    
    it_should_behave_like "login_required"
  end

end

describe SystemReportsController, "with an unauthorized user visiting" do
  describe "#completion_count" do
    integrate_views
  
    def do_request
      get :completion_count
    end
    
    before(:each) do
      logged_in_as_user
      @current_user.stub!(:allowed_to?).and_return(false)
    end

    it_should_behave_like "denied_access"
  end

end

describe SystemReportsController, "POST #completion_count" do
  integrate_views

  before(:each) do
    logged_in_as_admin
  end

  it 'should be successful' do
    get :completion_count
    response.should be_success
  end

  it 'should render the completion_count template' do
    get :completion_count
    response.should render_template('completion_count')
  end
end

describe SystemReportsController, "POST #completion_count" do
  integrate_views

  before(:each) do
    logged_in_as_admin
  end

  describe 'with valid data' do
    def data(additional_data={})
      {
        "start_date"=>"2009-07-01",
        "end_date"=>"2009-07-31",
        "users"=>["13", "14", "15", "16", "17", "18", "19", "20", "21"]
      }.merge(additional_data)
    end
    
    it 'should be successful' do
      post :completion_count, :completion_count => data
      response.should be_success
    end

    it 'should render the completion_count template' do
      post :completion_count, :completion_count => data
      response.should render_template('completion_count')
    end

    describe 'summary section' do
      before(:each) do
        @completion_count = CompletionCount.new(data)
        CompletionCount.should_receive(:new).and_return(@completion_count)
      end
      
      it 'should show the total incoming' do
        @completion_count.should_receive(:total_incoming).twice.and_return(42)
        post :completion_count, :completion_count => data
        response.should have_tag("tr.incoming td", "42")
      end

      it 'should show the total completed' do
        @completion_count.should_receive(:total_completed).twice.and_return(154)
        post :completion_count, :completion_count => data
        response.should have_tag("tr.completed td", "154")

      end

      it 'should show the difference' do
        @completion_count.should_receive(:total_incoming).twice.and_return(42)
        @completion_count.should_receive(:total_completed).twice.and_return(154)
        post :completion_count, :completion_count => data
        response.should have_tag("tr.difference td", "-112")
      end

    end

    describe 'user section' do
      it 'should show the sum of each tracker for the user'
    end
  end

  describe 'with invalid data' do
    it 'should render the completion_count template' do
      post :completion_count, {}
      response.should render_template('completion_count')
    end

    it 'should display the errors'
  end
end


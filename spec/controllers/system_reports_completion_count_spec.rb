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

describe SystemReportsController, "GET #completion_count" do
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

  def user_mocks
    @users = [
              mock_model(User, :id => 13, :name => 'Test 13', :valid? => true, :<=> => -1),
              mock_model(User, :id => 14, :name => 'Test 14', :valid? => true, :<=> => 1)
             ]
    @users.stub!(:sort).and_return(@users)

    User.stub!(:find).and_return(@users)
  end
  
  before(:each) do
    logged_in_as_admin
    user_mocks
  end

  describe 'with valid data' do
    def data(additional_data={})
      {
        "start_date"=>"2009-07-01",
        "end_date"=>"2009-07-31",
        "user_ids"=>["13", "14"]
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
      it 'should show the sum of each tracker for each user' do
        @bug = mock_model(Tracker, :name => 'Bug')
        @feature = mock_model(Tracker, :name => 'Feature')
        Tracker.should_receive(:all).at_least(:once).and_return do
          [@bug, @feature]
        end

        @completion_count = CompletionCount.new(data)
        CompletionCount.should_receive(:new).and_return(@completion_count)

        @completion_count.should_receive(:total_by_tracker_for_user).with(@bug, 13).and_return(12)
        @completion_count.should_receive(:total_by_tracker_for_user).with(@feature, 13).and_return(16)
        @completion_count.should_receive(:total_by_tracker_for_user).with(@bug, 14).and_return(24)
        @completion_count.should_receive(:total_by_tracker_for_user).with(@feature, 14).and_return(56)
        
        post :completion_count, :completion_count => data

        response.should have_tag("#user-13") do
          with_tag("tr#tracker-#{@bug.id}") do
            with_tag('td', '12')
          end
        end

        response.should have_tag("#user-13") do
          with_tag("tr#tracker-#{@feature.id}") do
            with_tag('td', '16')
          end
        end

        response.should have_tag("#user-14") do
          with_tag("tr#tracker-#{@bug.id}") do
            with_tag('td', '24')
          end
        end

        response.should have_tag("#user-14") do
          with_tag("tr#tracker-#{@feature.id}") do
            with_tag('td', '56')
          end
        end
        
      end

      it 'should show the total sum of closed issues for each user' do
        @completion_count = CompletionCount.new(data)
        CompletionCount.should_receive(:new).and_return(@completion_count)

        @completion_count.should_receive(:total_closed_for_user).with(13).and_return(185)
        @completion_count.should_receive(:total_closed_for_user).with(14).and_return(214)

        post :completion_count, :completion_count => data
        
        response.should have_tag("#user-13") do
          with_tag("tr.total-closed") do
            with_tag('td', '185')
          end
        end

        response.should have_tag("#user-14") do
          with_tag("tr.total-closed") do
            with_tag('td', '214')
          end
        end
      end      

    end
  end

  describe 'with invalid data' do
    it 'should render the completion_count template' do
      post :completion_count, {}
      response.should render_template('completion_count')
    end

    it 'should display the errors' do
      post :completion_count, {}
      assigns[:completion_count].should have(1).errors_on(:start_date)
      assigns[:completion_count].should have(1).errors_on(:end_date)

    end
  end
end


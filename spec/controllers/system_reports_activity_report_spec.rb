require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "with a anonymous user visiting" do
  describe "#activity_report" do
    integrate_views
  
    def do_request
      get :activity_report
    end
    
    it_should_behave_like "login_required"
  end

end

describe SystemReportsController, "with an unauthorized user visiting" do
  describe "#activity_report" do
    integrate_views
  
    def do_request
      get :activity_report
    end
    
    before(:each) do
      logged_in_as_user
      @current_user.stub!(:allowed_to?).and_return(false)
    end

    it_should_behave_like "denied_access"
  end

end

describe SystemReportsController, "GET #activity_report" do
  integrate_views

  before(:each) do
    logged_in_as_admin
  end

  it 'should be successful' do
    get :activity_report
    response.should be_success
  end

  it 'should render the activity report template' do
    get :activity_report
    response.should render_template('activity_report')
  end
end

describe SystemReportsController, "POST #activity_report" do
  integrate_views

  before(:each) do
    logged_in_as_admin
  end

  describe 'with valid data' do
    def data(additional_data={})
      {
        "start_date"=>"2009-07-01",
        "end_date"=>"2009-07-31"
      }.merge(additional_data)
    end
    
    it 'should be successful' do
      post :activity_report, :activity_report => data
      response.should be_success
    end

    it 'should render the activity_report template' do
      post :activity_report, :activity_report => data
      response.should render_template('activity_report')
    end

    describe 'results' do
      before(:each) do
        @another_user = mock_model(User,
                                   :admin? => false,
                                   :logged? => true,
                                   :anonymous? => false,
                                   :name => "Another User",
                                   :projects => Project,
                                   :time_zone => ActiveSupport::TimeZone.all.first,
                                   :language => 'en')

        @events = [
                   mock_model(Issue,
                              :event_url => 'issues/show/1001',
                              :event_title => 'Entered new issue',
                              :event_type => 'issue-new',
                              :event_description => "",
                              :event_datetime => DateTime.new(2009, 7, 10),
                              :event_date => Date.new(2009, 7, 10),
                              :event_author => @current_user,
                              :project => mock_model(Project)),
                   mock_model(Issue,
                              :event_url => 'issues/show/1002',
                              :event_title => 'Entered another new issue',
                              :event_type => 'issue-new',
                              :event_description => "",
                              :event_datetime => DateTime.new(2009, 7, 11),
                              :event_date => Date.new(2009, 7, 10),
                              :event_author => @current_user,
                              :project => mock_model(Project)),
                   mock_model(Journal,
                              :event_url => 'issues/show/1000',
                              :event_title => 'Entered new journal',
                              :event_type => 'issue-edit',
                              :event_description => "",
                              :event_datetime => DateTime.new(2009, 7, 12),
                              :event_date => Date.new(2009, 7, 10),
                              :event_author => @another_user,
                              :project => mock_model(Project)),
                   mock_model(Journal,
                              :project => nil,
                              :event_url => 'issues/show/1000',
                              :event_title => 'Entered another journal',
                              :event_description => "",
                              :event_type => 'issue-edit',
                              :event_datetime => DateTime.new(2009, 7, 19),
                              :event_date => Date.new(2009, 7, 10),
                              :event_author => @current_user,
                              :project => mock_model(Project))
                  ]
        @events_grouped_by_user = @events.group_by(&:event_author)
      end

      it 'should fetch all Activity data in the date range' do
        activity_report = ActivityReport.new
        activity_report.stub!(:default_users).and_return([@current_user, @another_user])
        activity_report.stub!(:start_date).and_return(data["start_date"])
        activity_report.stub!(:end_date).and_return(data["end_date"])
        activity_report.stub!(:valid?).and_return(true)

        activity_report.should_receive(:fetch).and_return(@events)
        activity_report.should_receive(:group_events_by_user).and_return(@events_grouped_by_user)
        ActivityReport.should_receive(:new).and_return(activity_report)
        
        post :activity_report, :activity_report => data
      end

      it 'should contain all of the days horizonatally'

      it 'should list each user separately'
    end

  end
  
  describe 'with invalid data' do
    it 'should render the activity_report template' do
      post :activity_report, {}
      response.should render_template('activity_report')
    end
    
    it 'should display the errors' do
      post :activity_report, {}
      assigns[:activity_report].should have(1).errors_on(:start_date)
      assigns[:activity_report].should have(1).errors_on(:end_date)
    end
  end
end


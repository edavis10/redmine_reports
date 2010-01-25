require File.dirname(__FILE__) + '/../test_helper'
require 'system_reports_controller'

# Re-raise errors caught by the controller.
class SystemReportsController; def rescue_action(e) raise e end; end

class SystemReportsControllerCompletionCountTest < ActionController::TestCase
  def setup
    @controller = SystemReportsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    build_anonymous_role
  end

  context "GET :completion_count" do
    context "as an anonymous user" do
      should 'be tested'
    end
    
    context "as an unauthorized user" do
      should 'be tested'
    end

    context "logged in as admin" do
      setup do
        @user = User.generate_with_protected!(:admin => true)
        @request.session[:user_id] = @user.id

        get :completion_count
      end

      should_respond_with :success
      should_render_template :completion_count

    end
  end

  context "POST :completion_count as an anonymous user" do
    should 'be tested'
  end

  context "POST :completion_count as an unauthorized user" do
    should 'be tested'
  end

  context "POST :completion_count as an admin" do
    setup do
      @user = User.generate_with_protected!(:admin => true)
      @request.session[:user_id] = @user.id
    end

    context "with valid data" do
      setup do
        @project = Project.generate!

        @user1 = User.generate_with_protected!(:admin => true)
        @user2 = User.generate_with_protected!(:admin => true)
        @bug = Tracker.generate!(:name => 'Bug')
        @feature = Tracker.generate!(:name => 'Feature')
        @project.trackers << @bug
        @project.trackers << @feature
        @open = IssueStatus.generate!
        @closed = IssueStatus.generate!(:is_closed => true)
        
        # Bug, Incoming, Completed, User1
        Issue.generate_for_project!(@project, {
                                      :assigned_to => @user1,
                                      :tracker => @bug,
                                      :created_on => 2.days.ago,
                                      :updated_on => 1.day.ago,
                                      :status => @closed
                                        })

        # Bug, Incoming, Open, User2
        Issue.generate_for_project!(@project, {
                                      :assigned_to => @user2,
                                      :tracker => @bug,
                                      :created_on => 2.days.ago,
                                      :updated_on => 1.day.ago,
                                      :status => @open
                                    })

        # Feature, Incoming, Completed, User2
        Issue.generate_for_project!(@project, {
                                      :assigned_to => @user2,
                                      :tracker => @feature,
                                      :created_on => 2.days.ago,
                                      :updated_on => 1.day.ago,
                                      :status => @closed
                                    })

        # Feature, out of date range
        Issue.generate_for_project!(@project, {
                                      :assigned_to => @user2,
                                      :tracker => @feature,
                                      :created_on => 2.weeks.ago,
                                      :updated_on => 9.days.ago,
                                      :status => @closed
                                    })

        post :completion_count, :completion_count => {
          "start_date"=> 1.week.ago.to_date.to_s,
          "end_date"=> Date.today.to_s,
          "user_ids"=>[@user1.id, @user2.id]
        }
      end

      should_respond_with :success
      should_render_template :completion_count

      context 'summary section' do
        should 'show the total incoming' do
          assert_select 'td#total-incoming', '3'
        end

        should 'show the total completed' do
          assert_select 'td#total-completed', '2'
        end

        should 'show the difference' do
          assert_select 'td#total-difference', '1'
        end
      end

      context 'user section' do
        should 'show the sum of each tracker for each user' do
          assert_select "#user-#{@user1.id}" do
            assert_select "tr#tracker-#{@bug.id}" do
              assert_select 'td','1'
            end
          end

          assert_select "#user-#{@user2.id}" do
            assert_select "tr#tracker-#{@bug.id}" do
              assert_select 'td','0'
            end
          end

          assert_select "#user-#{@user2.id}" do
            assert_select "tr#tracker-#{@feature.id}" do
              assert_select 'td','1'
            end
          end
        end

        should 'show the total sum of closed issues for each user' do
          assert_select("#user-#{@user1.id}") do
            assert_select("tr.total-closed") do
              assert_select('td', '1')
            end
          end

          assert_select("#user-#{@user2.id}") do
            assert_select("tr.total-closed") do
              assert_select('td', '1')
            end
          end

        end
        
      end
    end

    context 'with invalid data' do
      setup do
        post :completion_count, {}
      end

      should_respond_with :success

      should 'display the errors' do
        assert assigns['completion_count'].errors.on(:start_date)
        assert assigns['completion_count'].errors.on(:end_date)
      end
    end
  end
end


require File.dirname(__FILE__) + '/../test_helper'

class CompletionCountTest < ActiveSupport::TestCase
  def setup
    build_anonymous_role
    @admin = User.generate_with_protected!(:admin => true)
    User.current = @admin
  end
  
  context "#total_incoming" do
    should 'get a count of the number of issues created in the date range' do
      start_date = Date.yesterday
      end_date = Date.today
      created_on = start_date + 1.hour
      @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

      @project = Project.generate!
      Issue.generate_for_project!(@project, :created_on => created_on)
      Issue.generate_for_project!(@project, :created_on => created_on)
      Issue.generate_for_project!(@project, :created_on => created_on)
      Issue.generate_for_project!(@project, :created_on => created_on)

      assert_equal 4, @completion_count.total_incoming
    end
  end

  context "#total_completed" do
    should 'get the count of the number of tasks closed in the date range' do
      start_date = Date.yesterday
      end_date = Date.today
      updated_on = start_date + 1.hour
      @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

      @project = Project.generate!
      @closed = IssueStatus.generate!(:is_closed => true)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed)

      assert_equal 4, @completion_count.total_completed
      
    end
  end

  context "#total_by_tracker_for_user" do
    should 'count the number of closed issues in that tracker for the user' do
      start_date = Date.yesterday
      end_date = Date.today
      updated_on = start_date + 1.hour
      @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

      @project = Project.generate!
      @project.trackers << @tracker = Tracker.generate!
      @closed = IssueStatus.generate!(:is_closed => true)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin) do |issue|
        issue.tracker = @tracker 
      end
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin) do |issue|
        issue.tracker = @tracker 
      end
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin) do |issue|
        issue.tracker = @tracker 
      end
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin)

      assert_equal 3, @completion_count.total_by_tracker_for_user(@tracker, @admin)
    end
  end

  context '#total_closed_for_user' do
    should 'count the number of closed issues' do
      start_date = Date.yesterday
      end_date = Date.today
      updated_on = start_date + 1.hour
      @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

      @project = Project.generate!
      @closed = IssueStatus.generate!(:is_closed => true)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin)
      Issue.generate_for_project!(@project, :updated_on => updated_on, :status => @closed, :assigned_to => @admin)

      assert_equal 4, @completion_count.total_closed_for_user(@admin)
      
    end
  end
end

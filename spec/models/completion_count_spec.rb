require File.dirname(__FILE__) + '/../spec_helper'

describe CompletionCount, '#total_incoming' do
  it 'should get a count of the number of issues created in the date range' do
    start_date = Date.yesterday
    end_date = Date.today
    @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)
    Issue.should_receive(:visible).and_return(Issue)
    Issue.should_receive(:count).with(:conditions => ["#{Issue.table_name}.created_on >= (?) and #{Issue.table_name}.created_on <= (?)",
                                                      start_date,
                                                      end_date]).and_return(120)

    @completion_count.total_incoming.should eql(120)
  end
end

describe CompletionCount, '#total_completed' do
  it 'should get a count of the number of tasks that have been closed in the date range' do
    start_date = Date.yesterday
    end_date = Date.today
    @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

    IssueStatus.should_receive(:all).with(:conditions => {:is_closed => true}).and_return do
      [mock_model(IssueStatus, :id => 4), mock_model(IssueStatus, :id => 5), mock_model(IssueStatus, :id => 7)]
    end
    
    Issue.should_receive(:visible).and_return(Issue)
    conditions = ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.status_id IN (?)",
                  start_date,
                  end_date,
                  [4,5,7]
                 ]
    
    Issue.should_receive(:count).with(:conditions => conditions).and_return(100)

    @completion_count.total_completed.should eql(100)

  end
end

describe CompletionCount, '#total_by_tracker_for_user' do
  it 'should get a count of the number of tasks that are in the tracker for the user' do
    start_date = Date.yesterday
    end_date = Date.today
    @completion_count = CompletionCount.new(:start_date => start_date, :end_date => end_date)

    @tracker = mock_model(Tracker)

    Issue.should_receive(:visible).and_return(Issue)
    conditions = ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.tracker_id = (?) and #{Issue.table_name}.assigned_to_id = (?)",
                  start_date,
                  end_date,
                  @tracker.id,
                  123
                 ]
    
    Issue.should_receive(:count).with(:conditions => conditions).and_return(1200)
    
    @completion_count.total_by_tracker_for_user(@tracker, 123).should eql(1200)
  end
end

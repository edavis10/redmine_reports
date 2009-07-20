module Reports
  module CompletionCount
    def completion_count
      @completion_count = ::CompletionCount.new(params[:completion_count])
    end
  end
end

# Added the report and configure it's permissions
require 'dispatcher'
Dispatcher.to_prepare do
  SystemReportsController.add_report(:completion_count, Reports::CompletionCount, {:action => :completion_count, :label => :reports_completion_count})

  # TODO: A better core API?
  Redmine::AccessControl.map {|map|
    map.permission(:run_completion_count, {:system_reports => [:completion_count]})
  } if Redmine::AccessControl.permission(:run_completion_count).nil?
  
end

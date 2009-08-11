module Reports
  module ActivityReport
    def activity_report
      @activity_report = ::ActivityReport.new(params[:activity_report])
      if request.post? && @activity_report.valid?
        @activity_report.fetch
        @events_by_user = @activity_report.group_events_by_user
      end
    end
  end
end

# Added the report and configure it's permissions
require 'dispatcher'
Dispatcher.to_prepare do
  SystemReportsController.add_report(:activity_report, Reports::ActivityReport, {:action => :activity_report, :label => :reports_activity_report})

  # TODO: A better core API?
  Redmine::AccessControl.map {|map|
    map.permission(:run_activity_report, {:system_reports => [:activity_report]})
  } if Redmine::AccessControl.permission(:run_activity_report).nil?
  
end

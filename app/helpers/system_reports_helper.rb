module SystemReportsHelper
  def report_menu
    returning [] do |menu|
      SystemReportsController.reports.each do |report|
        menu << link_to(l(report[:label]),
                        {
                          :controller => 'system_reports',
                          :action => report[:action]
                        },
                        :class => "icon #{report[:class]}"
                        )
      end

      menu << link_to(l(:label_issue_view_all), { :controller => 'issues' }, :class => 'icon icon-issue')
      menu << link_to(l(:label_overall_activity), { :controller => 'projects', :action => 'activity' }, :class => 'icon icon-activity')

      menu << link_to(l(:label_details), {:controller => 'timelog', :action => 'details'}, :class => 'icon icon-time')
      menu << link_to(l(:label_report), {:controller => 'timelog', :action => 'report'}, :class => 'icon icon-time')

      
    end
  end
end

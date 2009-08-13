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

      menu << link_to(l(:reports_all_issues), { :controller => 'issues' }, :class => 'icon icon-issue')
      menu << link_to(l(:reports_system_activity), { :controller => 'projects', :action => 'activity' }, :class => 'icon icon-activity')

      menu << link_to(l(:reports_spent_time_details), {:controller => 'timelog', :action => 'details'}, :class => 'icon icon-time')
      menu << link_to(l(:reports_spent_time_reports), {:controller => 'timelog', :action => 'report'}, :class => 'icon icon-time')

      
    end
  end

  def select_size
    select_size = Setting.plugin_redmine_reports['select_size'] || 5
    select_size.to_i
  end
end

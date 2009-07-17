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
    end
  end
end

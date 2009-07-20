def path_to(page_name)
  case page_name
  
  when /homepage/i
    url_for(:controller => 'welcome')
  when /system report overview/i
    url_for(:controller => 'system_reports')
  when /quickbooks/i
    url_for(:controller => 'system_reports', :action => 'quickbooks')
  when /completion count/i
    url_for(:controller => 'system_reports', :action => 'completion_count')
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end

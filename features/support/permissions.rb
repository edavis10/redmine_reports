def permission_name_to_path(permission)
  case permission
  when :run_completion_count
    {:controller => 'system_reports', :action => 'completion_count'}
  when :run_activity_report
    {:controller => 'system_reports', :action => 'activity_report'}
  else
    raise "Can't find mapping from \"#{permission}\" to a path."
  end
end

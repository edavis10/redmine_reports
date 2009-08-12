class CompletionCount < EphemeralModel
  include Reports::ReportHelper

  def total_incoming
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.created_on >= (?) and #{Issue.table_name}.created_on <= (?)",
                                        start_date,
                                        end_date])
  end

  def total_completed
    closed_issue_status_ids = IssueStatus.all(:conditions => {:is_closed => true}).collect(&:id)
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.status_id IN (?)",
                         start_date,
                         end_date,
                         closed_issue_status_ids
                        ])

  end

  def total_by_tracker_for_user(tracker, user_id)
    closed_issue_status_ids = IssueStatus.all(:conditions => {:is_closed => true}).collect(&:id)
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.tracker_id = (?) and #{Issue.table_name}.assigned_to_id = (?) and #{Issue.table_name}.status_id IN (?)",
                         start_date,
                         end_date,
                         tracker.id,
                         user_id,
                         closed_issue_status_ids
                        ])
  end

  def total_closed_for_user(user_id)
    closed_issue_status_ids = IssueStatus.all(:conditions => {:is_closed => true}).collect(&:id)
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.status_id IN (?) and #{Issue.table_name}.assigned_to_id = (?)",
                         start_date,
                         end_date,
                         closed_issue_status_ids,
                         user_id
                        ])
  end
end

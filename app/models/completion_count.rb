class CompletionCount < EphemeralModel
  include Reports::ReportHelper

  def total_incoming
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.created_on >= (?) and #{Issue.table_name}.created_on <= (?) and #{Issue.table_name}.status_id IN (?)",
                         start_date,
                         end_date,
                         included_status_ids])
  end

  def total_completed
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.status_id IN (?)",
                         start_date,
                         end_date,
                         included_status_ids(:is_closed => true)
                        ])

  end

  def total_by_tracker_for_user(tracker, user_id)
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.tracker_id = (?) and #{Issue.table_name}.assigned_to_id = (?) and #{Issue.table_name}.status_id IN (?)",
                         start_date,
                         end_date,
                         tracker.id,
                         user_id,
                         included_status_ids(:is_closed => true)
                        ])
  end

  def total_closed_for_user(user_id)
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.status_id IN (?) and #{Issue.table_name}.assigned_to_id = (?)",
                         start_date,
                         end_date,
                         included_status_ids(:is_closed => true),
                         user_id
                        ])
  end

  private
  def included_status_ids(conditions={})
    all_statuses = IssueStatus.all(:conditions => conditions).collect(&:id)

    if Setting.plugin_redmine_reports['completion_count'].present? && Setting.plugin_redmine_reports['completion_count']['exclude_statuses'].present?
      return all_statuses - Setting.plugin_redmine_reports['completion_count']['exclude_statuses'].collect(&:to_i)
    else
      return all_statuses
    end
  end
end

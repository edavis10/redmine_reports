class CompletionCount < EphemeralModel
  column :start_date, :string
  column :end_date, :string

  has_many :users

  def default_users
    User.active
  end

  def selected_users_or_all_users
    users.blank? ? User.active : users
  end
    
  def selected_user_ids
    users.collect(&:id).collect(&:to_i) if users
  end

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
    Issue.visible.count(:conditions =>
                        ["#{Issue.table_name}.updated_on >= (?) and #{Issue.table_name}.updated_on <= (?) and #{Issue.table_name}.tracker_id = (?) and #{Issue.table_name}.assigned_to_id = (?)",
                         start_date,
                         end_date,
                         tracker.id,
                         user_id
                        ])
  end
end

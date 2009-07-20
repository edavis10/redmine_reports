class CompletionCount < EphemeralModel
  column :start_date, :string
  column :end_date, :string
  attr_accessor :users
  
  def default_users
    User.active
  end

  def selected_users
    users.collect(&:to_i) if users
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
end

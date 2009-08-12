class CompletionCount < EphemeralModel
  column :start_date, :string
  column :end_date, :string
  attr_accessor :selected_role_ids

  has_many :users
  has_many :roles

  validates_presence_of :start_date
  validates_presence_of :end_date

  def validate
    if self.end_date && self.start_date && self.end_date < self.start_date
      errors.add :end_date, :greater_than_start_date
    end
  end

  # Adds users based on which roles a User has.
  def role_ids=(role_ids)
    role_ids.each do |id|
      role = Role.find_by_id(id.to_i)
      if role
        self.users += role.members.collect(&:user).uniq
        @selected_role_ids ||= []
        @selected_role_ids << role.id
      end
    end
  end
  
  def default_users
    User.active
  end

  def selected_users_or_all_users
    users.blank? ? User.active : users
  end
    
  def selected_user_ids
    users.collect(&:id).collect(&:to_i) if users
  end

  def role_ids
    selected_role_ids || []
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

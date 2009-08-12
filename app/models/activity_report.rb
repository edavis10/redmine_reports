class ActivityReport < EphemeralModel
  column :start_date, :string
  column :end_date, :string
  attr_accessor :fetcher
  attr_accessor :events
  attr_accessor :events_by_user
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

  def fetch
    @fetcher = Redmine::Activity::Fetcher.new(User.current, {:with_subprojects => Setting.display_subprojects_issues?})
    @fetcher.scope = :all
    # Need to add one day to the ending date because Fetcher doesn't
    # include the ending date.
    patched_end_date = end_date.to_date + 1
    @events = @fetcher.events(start_date, patched_end_date.to_s).inject([]) do |matching_events, event|
      if selected_users_or_all_users.include?(event.event_author)
        matching_events << event
      end
      matching_events
    end
    @events
  end

  def group_events_by_user
    @events_by_user ||= @events.group_by(&:event_author)
  end
end

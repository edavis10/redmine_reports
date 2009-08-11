class ActivityReport < EphemeralModel
  column :start_date, :string
  column :end_date, :string
  attr_accessor :fetcher
  attr_accessor :events
  attr_accessor :events_by_user

  validates_presence_of :start_date
  validates_presence_of :end_date

  def validate
    if self.end_date && self.start_date && self.end_date < self.start_date
      errors.add :end_date, :greater_than_start_date
    end
  end

  def fetch
    @fetcher = Redmine::Activity::Fetcher.new(User.current, {:with_subprojects => Setting.display_subprojects_issues?})
    @fetcher.scope = :all
    # TODO: need to +1 end_date
    @events = @fetcher.events(start_date, end_date) 
  end

  def group_events_by_user
    @events_by_user ||= @events.group_by(&:event_author)
  end
end

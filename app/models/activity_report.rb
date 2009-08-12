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
    # Need to add one day to the ending date because Fetcher doesn't
    # include the ending date.
    patched_end_date = end_date.to_date + 1
    @events = @fetcher.events(start_date, patched_end_date.to_s)
  end

  def group_events_by_user
    @events_by_user ||= @events.group_by(&:event_author)
  end
end

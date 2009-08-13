class ActivityReport < EphemeralModel
  include Reports::ReportHelper

  attr_accessor :fetcher
  attr_accessor :events
  attr_accessor :events_by_user

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
    @events_by_user ||= @events.group_by(&:event_author).sort
  end
end

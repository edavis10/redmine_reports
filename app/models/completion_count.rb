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
end

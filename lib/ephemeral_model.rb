# From: http://www.pervasivecode.com/blog/2007/06/08/non-persistent-rails-model-classes-for-easier-validation/
# Code based on code found at http://www.railsweenie.com/forums/2/topics/724
class EphemeralModel < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
end

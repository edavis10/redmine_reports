module Reports
  module ReportHelper
    def self.included(base) # :nodoc:
      base.class_eval do
        column :start_date, :string
        column :end_date, :string

        attr_accessor :selected_role_ids

        has_many :users
        has_many :roles

        validates_presence_of :start_date
        validates_presence_of :end_date
        validate :start_date_is_before_end_date

        # Isn't working when defined in InstanceMethods
        def role_ids
          selected_role_ids || []
        end

        
        # Adds users based on which roles a User has.
        def role_ids=(v)
          v.each do |id|
            role = Role.find_by_id(id.to_i)
            if role
              self.users += role.members.collect(&:user).uniq.compact
              @selected_role_ids ||= []
              @selected_role_ids << role.id
            end
          end
        end
      end

      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def start_date_is_before_end_date
        if self.end_date && self.start_date && self.end_date < self.start_date
          errors.add :end_date, :greater_than_start_date
        end
      end

      def default_users
        User.active.sort
      end

      def selected_users_or_all_users
        users.blank? ? User.active.sort : users.sort
      end
      
      def selected_user_ids
        users.collect(&:id).collect(&:to_i) if users
      end
    end
  end
end


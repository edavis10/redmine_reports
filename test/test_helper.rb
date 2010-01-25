# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

# Helpers
class ActiveSupport::TestCase
  def configure_plugin(fields={})
    Setting.plugin_redmine_reports = fields.stringify_keys
  end

  def setup_plugin_configuration
    configure_plugin({
                     })
  end

  def build_anonymous_role
    @role = Role.generate!
    @role.update_attribute(:builtin,  Role::BUILTIN_ANONYMOUS)
  end

end

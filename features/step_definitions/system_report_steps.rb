# Steps for Reports
Before do
  User.destroy_all
  @current_user = User.new(:mail => 'test@example.com', :firstname => 'Feature', :lastname => 'Test')
  @current_user.login = 'feature_test'
  @current_user.save!
end

Given /^I am logged in as an Administrator$/ do
  @current_user.stubs(:admin?).returns(true)
  User.stubs(:current).returns(@current_user)
end

Given /^I am logged in as a User$/ do
  @current_user.stubs(:admin?).returns(false)
  User.stubs(:current).returns(@current_user)
end

Given /^I am not logged in$/ do
  User.stubs(:current).returns(User.anonymous)
end

Given /^I am on the system report overview page$/ do
  visit "/system_reports"
end

Given /^I am on the home page$/ do
  visit "/"
end

When /^I visit the "system report overview" page$/ do
  visit "/system_reports"
end

When /^I visit the "quickbooks" page$/ do
  visit "/system_reports/quickbooks"
end

Then /^I should see a menu called "(.*)"$/ do |named|
  response.should have_tag("div.contextual##{named}")
end

Then /^I should see a link "(.*)"$/ do |text|
  response.should have_tag("a", /#{text}/i)
end

Then /^I should be on the "quickbooks" page$/ do
  current_url.should =~ %r{/quickbooks$} 
end

Then /^I should be denied access$/ do
  response.should_not be_success
  response.code.should eql("403")
  response.should render_template('common/403')
end

Then /^I should go to the login page$/ do
  response.request.path_parameters["action"].should eql("login")
end


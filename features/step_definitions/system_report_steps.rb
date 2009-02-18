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

Given /^I am on the system report overview page$/ do
  visit "/system_reports"
end

Then /^I should see a list called "(.*)"$/ do |named|
  response.should have_tag("ul##{named}")
end


Then /^I should be on the "quickbooks" page$/ do
  current_url.should =~ %r{/quickbooks$} 
end

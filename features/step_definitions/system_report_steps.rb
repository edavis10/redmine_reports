# Steps for Reports
Before do
  User.destroy_all
  @current_user = User.new(:mail => 'test@example.com', :firstname => 'Feature', :lastname => 'Test')
  @current_user.login = 'feature_test'
  @current_user.save!
end

def unbilled_po_data
  [
   ["Project A", 100.0],
   ["Project B", 350.43],
   ["Project C", 23.45],
   ["Project D", 0]
  ]
end

def setup_unbilled_po_data
  @unbilled_pos = unbilled_po_data
  @unbilled_po_total = 473.88
  unbilled_po_data.each do |project_po|
    project = Project.new(:name => project_po[0], :identifier => project_po[0], :total_value => project_po[1])
    project.save(false)
  end
end

def unspent_labor_data
  [
   ["Project A", 1000.0],
   ["Project B", 1234.56],
   ["Project C", 123.45],
   ["Project D", 0]
  ]
end

def setup_unspent_labor_data
  @unspent_labor = unspent_labor_data
  @unspent_labor_total = 2358.01
end

def unbilled_labor_data
  [
   ["User A", 2000.0],
   ["User B", 2234.56],
   ["User C", 223.45],
   ["User D", 0]
  ]
end

def setup_unbilled_labor_data
  @unbilled_labor = unbilled_labor_data
  @unbilled_labor_total = 4458.01
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

Given /^I am on the system report quickbooks page$/ do
  setup_unbilled_po_data
  setup_unspent_labor_data
  setup_unbilled_labor_data
  visit "/system_reports/quickbooks"
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

Then /^I should see the "Unbilled PO" total$/ do
  response.should have_tag("h3#unbilled_po_total", /#{@unbilled_po_total}/)
end

Then /^I should see the "Unbilled PO" subtotals$/ do
  response.should have_tag("table#unbilled_po") do
    @unbilled_pos.each do |po|
      with_tag("td.unbilled_po_amount",/#{po[1]}/)
    end
  end
end

Then /^I should see the "Unspent Labor" total$/ do
  # TODO: find actual amounts
  response.should have_tag("h3#unspent_labor_total")
end

# TODO: Needs actual amounts in order to test
# Then /^I should see the "Unspent Labor" subtotals$/ do
#   response.should have_tag("table#unspent_labor") do
#      @unspent_labor.each do |labor|
#        with_tag("td.unspent_labor_amount")
#      end
#    end
# end


Then /^I should see the "Unbilled Labor" total$/ do
  # TODO: find actual amounts
  response.should have_tag("h3#unbilled_labor_total")
end

# TODO: Needs actual amounts in order to test
# Then /^I should see the "Unbilled Labor" subtotals$/ do
#   response.should have_tag("table#unbilled_labor") do
#      @unbilled_labor.each do |labor|
#        with_tag("td.unbilled_labor_amount")
#      end
#    end
# end

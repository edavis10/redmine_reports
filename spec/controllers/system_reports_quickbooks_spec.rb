require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "#quickbooks" do
  integrate_views
  include ActionView::Helpers::NumberHelper

  def total_po_data
    {
     'a' => 100.0,
     'b' => 350.43,
     'c' => 23.45,
     'd' =>  0
    }
  end

  def total_po_projects
    project_a = mock_model(Project, :total_value => total_po_data['a'], :name => "Project A")
    project_b = mock_model(Project, :total_value => total_po_data['b'], :name => "Project B")
    project_c = mock_model(Project, :total_value => total_po_data['c'], :name => "Project C")
    project_d = mock_model(Project, :total_value => total_po_data['d'], :name => "Project D")

    [project_a, project_b, project_c, project_d]
  end
  
  def unspent_labor_data
    [
     ["Project A", 1000.0],
     ["Project B", 3500.43],
     ["Project C", 230.45],
     ["Project D", 0]
    ]
  end

  def unbilled_labor_data
    [
     ["User A", 10.0],
     ["User B", 35.43],
     ["User C", 2.45],
     ["User D", 0]
    ]
  end

  before(:each) do
    logged_in_as_admin
    Project.stub!(:all).and_return([]) # Project jump box conflicts with mocks below
    Project.stub!(:find).with(:all).and_return(total_po_projects)
    BillingExport.stub!(:unspent_labor).and_return(unspent_labor_data)
    BillingExport.stub!(:unbilled_labor).and_return(unbilled_labor_data)
  end

  it 'should be successful' do
    get :quickbooks
    response.should be_success
  end

  it 'should render the index template' do
    get :quickbooks
    response.should render_template('quickbooks')
  end

  describe 'exporting the total po from the Billing plugin' do
    it 'should get the total value for each project' do
      Project.should_receive(:find).with(:all).and_return(total_po_projects)
      get :quickbooks
    end

    it 'should show the total of the total po' do
      get :quickbooks
      total = total_po_data.collect {|project, value| value }.sum
      response.should have_tag("tr#total_po_total", /#{total.to_s}/)
    end

    it 'should show the amounts for each project as a currency' do
      get :quickbooks
      response.should have_tag("table#total_po") do
        with_tag("td.total_po_amount",'$100.00')
        with_tag("td.total_po_amount",'$350.43')
        with_tag("td.total_po_amount",'$23.45')
      end
    end

    it 'should not show the amount for a project with 0' do
      get :quickbooks
      response.should_not have_tag("td.total_po_project",'Project D')
      response.should_not have_tag("td.total_po_amount",'$0')
    end
  end

  describe 'exporting the unspent labor from the Billing plugin' do
    it 'should use BillingExport#unspent_labor' do
      BillingExport.should_receive(:unspent_labor).and_return(unspent_labor_data)
      get :quickbooks
    end

    it 'should show the total of the unspent labor' do
      get :quickbooks
      total = unspent_labor_data.collect {|item| item[1] }.sum
      response.should have_tag("tr#unspent_labor_total", /#{number_with_delimiter(total)}/)
    end

    it 'should show the amounts for each project as a currency' do
      get :quickbooks
      response.should have_tag("table#unspent_labor") do
        with_tag("td.unspent_labor_amount",'$1,000.00')
        with_tag("td.unspent_labor_amount",'$3,500.43')
        with_tag("td.unspent_labor_amount",'$230.45')
      end
    end

    it 'should not show the amount for a project with 0' do
      get :quickbooks
      response.should_not have_tag("td.unspent_labor_user",'Project D')
      response.should_not have_tag("td.unspent_labor_amount",'$0')
    end
  end

  describe 'exporting the unbilled labor from the Billing plugin' do
    it 'should use BillingExport#unbilled_labor' do
      BillingExport.should_receive(:unbilled_labor).and_return(unbilled_labor_data)
      get :quickbooks
    end

    it 'should show the total of the unbilled labor' do
      get :quickbooks
      total = unbilled_labor_data.collect {|item| item[1] }.sum
      response.should have_tag("tr#unbilled_labor_total", /#{number_with_delimiter(total)}/)
    end

    it 'should show the amounts for each user as a currency' do
      get :quickbooks
      response.should have_tag("table#unbilled_labor") do
        with_tag("td.unbilled_labor_amount",'$10.00')
        with_tag("td.unbilled_labor_amount",'$35.43')
        with_tag("td.unbilled_labor_amount",'$2.45')
      end
    end

    it 'should not show the amount for a user with 0' do
      get :quickbooks
      response.should_not have_tag("td.unspent_labor_user",'User D')
      response.should_not have_tag("td.unspent_labor_amount",'$0')
    end
  end
end

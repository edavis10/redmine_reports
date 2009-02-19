require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "#quickbooks" do
  integrate_views

  def unbilled_po_data
    [
     ["Project A", 100.0],
     ["Project B", 350.43],
     ["Project C", 23.45],
     ["Project D", 0]
    ]
  end

  before(:each) do
    logged_in_as_admin
    BillingExport.stub!(:unbilled_po).and_return(unbilled_po_data)
  end

  it 'should be successful' do
    get :quickbooks
    response.should be_success
  end

  it 'should render the index template' do
    get :quickbooks
    response.should render_template('quickbooks')
  end

  describe 'exporting the unbilled po from the Billing plugin' do
    it 'should use BillingExport#unbilled_po' do
      BillingExport.should_receive(:unbilled_po).and_return(unbilled_po_data)
      get :quickbooks
    end

    it 'should show the total of the unbilled po' do
      get :quickbooks
      total = unbilled_po_data.collect {|po_item| po_item[1] }.sum
      response.should have_tag("h3#unbilled_po_total", /#{total.to_s}/)
    end

    it 'should show the amounts for each project as a currency' do
      get :quickbooks
      response.should have_tag("table#unbilled_po") do
        with_tag("td.unbilled_po_amount",'$100.00')
        with_tag("td.unbilled_po_amount",'$350.43')
        with_tag("td.unbilled_po_amount",'$23.45')
      end
    end

    it 'should not show the amount for a project with 0' do
      get :quickbooks
      response.should_not have_tag("td.unbilled_po_project",'Project D')
      response.should_not have_tag("td.unbilled_po_amount",'$0')
    end
  end
end

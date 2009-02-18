require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "#quickbooks" do
  integrate_views
  
  it 'should be successful' do
    get :quickbooks
    response.should be_success
  end

  it 'should render the index template' do
    get :quickbooks
    response.should render_template('quickbooks')
  end
end

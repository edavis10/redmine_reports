require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "#index" do
  integrate_views

  before(:each) do
    logged_in_as_admin
  end
  
  it 'should be successful' do
    get :index
    response.should be_success
  end

  it 'should render the index template' do
    get :index
    response.should render_template('index')
  end

  it 'should show a link to the Quickbooks report' do
    get :index
    response.should have_tag('li > a','Quickbooks')
  end
end

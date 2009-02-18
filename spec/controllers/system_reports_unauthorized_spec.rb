require File.dirname(__FILE__) + '/../spec_helper'

describe SystemReportsController, "with an unauthorized user visiting" do
  describe "#index" do
    integrate_views
  
    it 'should not be successful'
    it 'should return a 403 status code'
    it 'should display the standard unauthorized page'
  end

  describe "#quickbooks" do
    integrate_views
  
    it 'should not be successful'
    it 'should return a 403 status code'
    it 'should display the standard unauthorized page'
  end

end

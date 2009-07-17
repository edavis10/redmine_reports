require_dependency 'application'

class SystemReportsController < ApplicationController
  before_filter :require_admin
  unloadable
  
  def index
  end

  def self.require_admin(action=nil)

  end
end

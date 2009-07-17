require_dependency 'application'

class SystemReportsController < ApplicationController
  before_filter :require_admin
  unloadable

  cattr_accessor :reports
  
  def index
  end

  def self.add_report(name, report_module, options={})
    self.send(:include, report_module) if report_module
    self.reports ||= []
    report = {
      :name => name,
      :menu_name => options[:menu_name] || name,
      :action => options[:action] || name,
      :label => options[:label] || :reports_unnamed,
      :class => options[:class]
    }
    
    self.reports << report
    self
  end
  
  def self.require_admin(action=nil)

  end
end

SystemReportsController.add_report(:index, nil, :label => :reports_overview)

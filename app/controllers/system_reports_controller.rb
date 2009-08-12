require_dependency 'application'

class SystemReportsController < ApplicationController
  unloadable
  before_filter :check_permissions

  cattr_accessor :reports
  cattr_accessor :admin_required

  self.admin_required = []
  
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
    self.reports.uniq!
    self
  end
  
  def self.require_admin(action)
    self.admin_required ||= []
    self.admin_required << action.to_sym
    self.admin_required.uniq!
  end

  private

  def check_permissions
    if SystemReportsController.admin_required.include?(params[:action].to_sym)
      return require_admin
    end

    if params[:controller] == 'system_reports' &&  params[:action] == 'index'
      return require_login
    else
      return authorize_global
    end
  end
end

SystemReportsController.add_report(:index, nil, :label => :reports_overview)

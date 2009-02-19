class SystemReportsController < ApplicationController
  before_filter :require_admin

  def index
  end

  def quickbooks
    @unbilled_po = BillingExport.unbilled_po
    @unbilled_po_total = @unbilled_po.collect {|po_item| po_item[1].to_f}.sum

    @unspent_labor = BillingExport.unspent_labor
    @unspent_labor_total = @unspent_labor.collect {|labor| labor[1].to_f}.sum
  end
end

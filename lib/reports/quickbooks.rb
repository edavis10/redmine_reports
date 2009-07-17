module Reports
  module Quickbooks
    def quickbooks
      @unbilled_po = BillingExport.unbilled_po
      @unbilled_po_total = @unbilled_po.collect {|po_item| po_item[1].to_f}.sum

      @unspent_labor = BillingExport.unspent_labor
      @unspent_labor_total = @unspent_labor.collect {|labor| labor[1].to_f}.sum

      @unbilled_labor = BillingExport.unbilled_labor
      @unbilled_labor_total = @unbilled_labor.collect {|labor| labor[1].to_f}.sum
    end
  end
end

SystemReportsController.send(:include, Reports::Quickbooks)
SystemReportsController.require_admin(:quickbooks)

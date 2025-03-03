# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # https://www.orca.med.or.jp/receipt/tec/api/report_print/seikyusho.html
  class InvoiceReceiptService < Service
    def get(invoice_number, patient_id)
      api_path = "/api01rv2/invoicereceiptv2"
      req_name = "invoice_receiptv2req"
      body = {
        req_name => {
          "Request_Number" => '01',
          "Patient_ID" => patient_id,
          "Invoice_Number" => invoice_number,
        }
      }
      FormResult.new(orca_api.call(api_path, body: body))
    end
  end
end

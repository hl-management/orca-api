# frozen_string_literal: true
require_relative "service"

module OrcaApi
  # @see https://www.orca.med.or.jp/receipt/tec/api/report_print/meisaisho.html
  class StatementService < Service
    def get(patient_id, invoice_number)
      api_path = "/api01rv2/statementv2"
      req_name = "statementv2req"
        body = {
          req_name => {
            "Patient_ID" => patient_id,
            "Invoice_Number" => invoice_number,
            "Request_Number" => '01',
          }
        }
      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

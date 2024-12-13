# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # https://www.orca.med.or.jp/receipt/tec/api/shunou.html
  class IncomeInformationService < Service
    def list(patient_id = "", date = "", month = "", year = "")
      api_path = "/api01rv2/incomeinfv2"
      req_name = "private_objects"
      params = {}
      params = params.merge({ "Perform_Date" => date }) if date.present?
      params = params.merge({ "Perform_Month" => month }) if month.present?
      params = params.merge({ "Perform_Year" => year }) if year.present?
      body = {
        req_name => {
          "Patient_ID" => patient_id,
        }.merge(params)
      }
      Result.new(orca_api.call(api_path, body: body))
    end

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

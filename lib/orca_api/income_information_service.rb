# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # https://www.orca.med.or.jp/receipt/tec/api/shunou.html
  class IncomeInformationService < Service
    def list(patient_id = "", date = "", month = "", year = "")
      api_path = "/api01rv2/incomeinfv2"
      req_name = "private_objects"
      params = {}
      params.merge({ "Perform_Date" => date }) if date.present?
      params.merge({ "Perform_Month" => month }) if month.present?
      params.merge({ "Perform_Year" => year }) if year.present?
      body = {
        req_name => {
          "Patient_ID" => patient_id,
        }.merge(params)
      }

      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

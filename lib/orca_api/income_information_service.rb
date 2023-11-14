# frozen_string_literal: true
require_relative 'service'

module OrcaApi
  class IncomeInformationService < Service
    # https://www.orca.med.or.jp/receipt/tec/api/shunou.html

    def list(patient_id = "", date = "", month = "", year = "")
      api_path = "/api01rv2/incomeinfv2"
      req_name = "private_objects"
      body = {
        req_name => {
          "Patient_ID" => patient_id,
          "Perform_Date" => date,
          "Perform_Month" => month,
          "Perform_Year" => year,
        }
      }

      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

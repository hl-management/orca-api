# frozen_string_literal: true
require_relative 'service'

module OrcaApi
  class InformationService < Service
    # https://www.orca.med.or.jp/receipt/tec/api/shunou.html

    def list(base_date = "", patient_id = "", type = "date")
      api_path = "/api01rv2/incomeinfv2"
      req_name = "private_objects"
      if type == "date"
        body = {
          req_name => {
            "Patient_ID" => patient_id,
            "Perform_Date" => base_date,
          }
        }
      else
        body = {
          req_name => {
            "Patient_ID" => patient_id,
            "Perform_Month" => base_date,
          }
        }
      end

      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

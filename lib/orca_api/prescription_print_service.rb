# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # 処方箋
  class PrescriptionPrintService < Service
    def get_medical_fee(params)
      body = {
        "Request_Number" => "01",
        "Karte_Uid" => params["Karte_Uid"],
        "Patient_ID" => params["Patient_ID"],
        "Perform_Date" => params["Perform_Date"],
        "Perform_Time" => params["Perform_Time"],
        "Patient_Mode" => params["Patient_Mode"],
        "Diagnosis_Information" => params["Diagnosis_Information"],
      }

      Result.new(call_01(body))
    end

    def medical_treatment(params)
      params = params.merge({
                              "Request_Number" => "02",
                            })

      Result.new(medical_call(params))
    end

    def medical_check(params)
      params = params.merge({
                              "Request_Number" => "03",
                            })

      Result.new(medical_call(params))
    end

    private

    def call_01(params)
      orca_api.call("/api21/medicalmodv31", body: {
                      "medicalv3req1" => params
                    })
    end

    def medical_call(params)
      orca_api.call("/api21/medicalmodv32", body: {
                      "medicalv3req2" => params,
                    })
    end
  end
end

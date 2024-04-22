# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # 処方箋
  class PrescriptionPrintService < Service
    def get_medical_fee(params)
      body = {
        "medicalv3req1" => params
      }
      Result.new(call_with_class_number("01", body, '/api21/medicalmodv31'))
    end

    def medical_treatment(params)
      body = {
        "medicalv3req2" => params
      }
      Result.new(call_with_class_number("02", body, '/api21/medicalmodv32'))
    end

    def medical_check(params)
      body = {
        "medicalv3req2" => params
      }
      Result.new(call_with_class_number("02", body, '/api21/medicalmodv32'))
    end

    private

    # def call_01(params)
    #   orca_api.call("/api21/medicalmodv31", body: {
    #                   "medicalv3req1" => params
    #                 })
    # end

    # def medical_call(params)
    #   orca_api.call("/api21/medicalmodv32", body: {
    #                   "medicalv3req2" => params,
    #                 })
    # end

    def call_with_class_number(class_number, body, path)
      orca_api.call(
        path,
        params: { class: class_number },
        body: body
      )
    end
  end
end

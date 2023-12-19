module OrcaApi
  class PatientService < Service
    # 全保険組合せ一覧取得API
    #
    # @see https://www.orca.med.or.jp/receipt/tec/api/insurancecombi.html
    class AllHealthInsurances < Service
      def get(id, params)
        api_path = "/api01rv2/patientlst6v2"

        base_params = {
          "Reqest_Number" => "01",
          "Patient_ID" => id.to_s
        }

        body = { "patientlst6req" => params.merge(base_params) }

        Result.new(orca_api.call(api_path, body: body))
      end
    end
  end
end

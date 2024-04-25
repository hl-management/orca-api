module OrcaApi
  class OrcaQkanService < Service
    # 利用者向け請求書取得API
    class PatientPaygetService < Service
      def get(provider_id, date, result_type = 'pdf')
        orca_api.call(
          "/claim01/patientpayget",
          format: 'xml',
          body: <<-XML
              <data>
                <patientpaygetreq type="record">
                  <Claim_Date type="string">#{date}</Claim_Date>
                  <Provider_Id type="string">#{provider_id}</Provider_Id>
                </patientpaygetreq>
              </data>
          XML
        )
      end
    end
  end
end

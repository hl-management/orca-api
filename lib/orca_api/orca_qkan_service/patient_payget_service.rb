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
                <Provider_Id type="string">1312345678</Provider_Id>
                <!-- 2_請求年月(デフォルト:現在日(年月)) -->
                <Claim_Date type="string">2024-03</Claim_Date>
                </patientpaygetreq>
              </data>
          XML
        )
      end
    end
  end
end

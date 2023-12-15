module OrcaApi
  class OrcaQkanService < Service
    class PatientPaygetService < Service
      def get(provider_id, date, type)
          orca_api.call(
            "/claim01/patientpayget",
            type: 'xml',
            body: <<-XML
              <data>
                <patientpaygetreq type="record">
                  <Claim_Date type="string">#{date}</Claim_Date>
                  <Result_Type type="string">#{type}</Result_Type>
                  <Provider_Id type="string">#{provider_id}</Provider_Id>
                </patientpaygetreq>
              </data>
            XML
          )
      end
    end
  end
end

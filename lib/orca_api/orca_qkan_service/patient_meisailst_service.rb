module OrcaApi
  class OrcaQkanService < Service
    # 介護給付費明細書一覧取得API
    class PatientMeisailstService < Service
      def get(provider_id, date)
        orca_api.call(
          "/claim01/meisailst",
          format: 'xml',
          body: <<-XML
              <data>
                <meisailstreq type="record">
                  <Claim_Date type="string">#{date}</Claim_Date>
                  <Provider_Id type="string">#{provider_id}</Provider_Id>
                </meisailstreq>
              </data>
          XML
        )
      end
    end
  end
end

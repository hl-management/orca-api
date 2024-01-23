module OrcaApi
  class OrcaQkanService < Service
    # 患者サービス API
    class PatientQkanService < Service
      def create(params)
        orca_api.call(
          "/patient01/patientadd",
          format: 'xml',
          body: <<-XML
          <data>
            <patientaddreq type="record">
              <Patient_Family_Name type="string">#{params[:last_name]}</Patient_Family_Name>
              <Patient_First_Name type="string">#{params[:first_name]}</Patient_First_Name>
              <Patient_Family_Kana type="string">#{params[:last_kana_name]}</Patient_Family_Kana>
              <Patient_First_Kana type="string">#{params[:first_kana_name]}</Patient_First_Kana>
              <Patient_Sex type="string">#{params[:gender]}</Patient_Sex>
              <Patient_Birthday type="string">#{params[:birthday]}</Patient_Birthday>
            </patientaddreq>
          </data>
          XML
        )
      end
    end
  end
end

module OrcaApi
  class OrcaQkanService < Service
    # 患者サービス API
    class QkanPatientService < Service
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
              <Patient_Code type="string">#{params[:orca_patient_no]}</Patient_Code>
            </patientaddreq>
          </data>
          XML
        )
      end

      def update(params)
        orca_api.call(
          "/patient01/patientmod",
          format: 'xml',
          body: <<-XML
          <data>
            <patientmodreq type="record">
              <Request_Number type="string">02</Request_Number>
              <Patient_Id type="string">#{params[:qkan_patient_no]}</Patient_Id>
              <Patient_Family_Name type="string">#{params[:last_name]}</Patient_Family_Name>
              <Patient_First_Name type="string">#{params[:first_name]}</Patient_First_Name>
              <Patient_Family_Kana type="string">#{params[:last_kana_name]}</Patient_Family_Kana>
              <Patient_First_Kana type="string">#{params[:first_kana_name]}</Patient_First_Kana>
              <Patient_Sex type="string">#{params[:gender]}</Patient_Sex>
              <Patient_Birthday type="string">#{params[:birthday]}</Patient_Birthday>
            </patientmodreq>
          </data>
          XML
        )
      end

      def get(patient_id)
        orca_api.call(
          "/patient01/patientinf",
          format: 'xml',
          body: <<-XML
          <data>
            <patientinfreq type="record">
              <Patient_Id type="integer">#{patient_id}</Patient_Id>
            </patientinfreq>
          </data>
          XML
        )
      end

      def list(start_date, end_date)
        orca_api.call(
          "/patient01/patientidlst1",
          format: 'xml',
          body: <<-XML
          <data>
            <patientidlst1req type="record">
                <Base_StartDate type="string">#{start_date}</Base_StartDate>
                <Base_EndDate type="string">#{end_date}</Base_EndDate>
            </patientidlst1req>
          </data>
          XML
        )
      end
    end
  end
end

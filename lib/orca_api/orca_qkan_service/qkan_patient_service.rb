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
              <PatientNinteiHistory_Information type="array">
                #{params[:nintei_history_information].to_a.map { |h| build_nintei_history_xml(h) }.join}
              </PatientNinteiHistory_Information>
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

      def create_nintei_history(patient_id, nintei_histories)
        nintei_xml = Array(nintei_histories).map { |h| build_nintei_history_xml(h) }.join
        call_nintei_history_api('01', patient_id, nintei_xml)
      end

      def update_nintei_history(nintei_histories)
        nintei_xml = Array(nintei_histories).map { |h| build_nintei_history_xml(h) }.join
        call_nintei_history_api('02', nil, nintei_xml)
      end

      def delete_nintei_history(update_keys)
        nintei_xml = Array(update_keys).map { |key| build_delete_nintei_history_xml(key) }.join
        call_nintei_history_api('03', nil, nintei_xml)
      end

      private

      def call_nintei_history_api(request_number, patient_id, nintei_xml)
        orca_api.call(
          "/patient01/nintei_historymod",
          format: 'xml',
          body: <<-XML
          <data>
            <ninteihistorymodreq type="record">
              <Request_Number type="string">#{request_number}</Request_Number>
              <Patient_Id type="string">#{patient_id}</Patient_Id>
              <PatientNinteiHistory_Information type="array">
                #{nintei_xml}
              </PatientNinteiHistory_Information>
            </ninteihistorymodreq>
          </data>
          XML
        )
      end

      def build_nintei_history_xml(nintei_history)
        h = nintei_history || {}
        fields = [
          xml_field('Update_Key', 'string', h[:update_key]),
          xml_field('Insurer_Id', 'integer', h[:insurer_id]),
          xml_field('Insured_Id', 'string', h[:insured_id]),
          xml_field('Insure_Rate', 'integer', h[:insure_rate]),
          xml_field('Planner', 'string', h[:planner]),
          xml_field('Provider_Id', 'string', h[:provider_id]),
          xml_field('Shubetsu_Code', 'integer', h[:shubetsu_code]),
          xml_field('Change_Code', 'integer', h[:change_code]),
          xml_field('Jotai_Code', 'string', h[:jotai_code]),
          xml_field('Insure_Valid_Start', 'string', h[:insure_valid_start]),
          xml_field('Insure_Valid_End', 'string', h[:insure_valid_end]),
          xml_field('System_Insure_Valid_Start', 'string', h[:system_insure_valid_start]),
          xml_field('System_Insure_Valid_End', 'string', h[:system_insure_valid_end]),
          xml_field('Shinsei_Date', 'string', h[:shinsei_date]),
          xml_field('Nintei_Date', 'string', h[:nintei_date]),
          xml_field('Stop_Date', 'string', h[:stop_date]),
          xml_field('Stop_Reason', 'integer', h[:stop_reason]),
          xml_field('Reported_Date', 'string', h[:reported_date]),
          xml_field('Shortstay_Use_Init_Count', 'integer', h[:shortstay_use_init_count]),
          xml_field('Limit_Change_Flag', 'integer', h[:limit_change_flag]),
        ].compact

        <<-XML
                <PatientNinteiHistory_Information_child type="record">
                  #{fields.join("\n                  ")}
                </PatientNinteiHistory_Information_child>
        XML
      end

      def xml_field(name, type, value)
        return nil if value.nil? || value.to_s.empty?

        "<#{name} type=\"#{type}\">#{value}</#{name}>"
      end

      def build_delete_nintei_history_xml(update_key)
        <<-XML
                <PatientNinteiHistory_Information_child type="record">
                  <Update_Key type="string">#{update_key}</Update_Key>
                </PatientNinteiHistory_Information_child>
        XML
      end
    end
  end
end

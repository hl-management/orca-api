module OrcaApi
  class OrcaQkanService < Service
    # 患者サービス API
    class QkanInformationChangeService < Service
      def create(params)
        orca_api.call(
          "/service01/servicemod",
          format: 'xml',
          body: <<-XML
          <data>
            <servicemodreq type="record">
              <Request_Number type="string">#{params[:Request_Number]}</Request_Number>
              <Patient_Id type="string">#{params[:Patient_Id]}</Patient_Id>
              <Service_YM type="string">#{params[:Service_YM]}</Service_YM>
              <Service_Code_Kind type="string">#{params[:Service_Code_Kind]}</Service_Code_Kind>
              <Service_Information type='array'>
                    #{params[:Service_Information] ? service_information_items_xml(params) : ''}
              </Service_Information>
            </servicemodreq>
          </data>
          XML
        )
      end

      private

      def service_information_items_xml(params)
        params[:Service_Information].map do |item|
          <<~XML
            <Service_Information_child type="record">
              <Service_Code_Kind type="string">#{item[:Service_Code_Kind]}</Service_Code_Kind>
              <Provider_Id type="string">#{item[:Provider_Id]}</Provider_Id>
              <Service_Code type="string">#{item[:Service_Code]}</Service_Code>
              <Service_Days type="string">#{item[:Service_Days]}</Service_Days>
            </Service_Information_child>
          XML
        end.join("\n")
      end
    end
  end
end

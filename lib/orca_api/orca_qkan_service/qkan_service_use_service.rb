module OrcaApi
  class OrcaQkanService < Service
    # 予定・実績情報変更API
    class QkanServiceUseService < Service
      def update(params)
        orca_api.call(
          "/service01/servicemod",
          format: 'xml',
          body: build_xml_request(params)
        )
      end

      private

      def build_xml_request(params)
        <<~XML
          <data>
            <servicemodreq type="record">
              <Request_Number type="string">#{params[:Request_Number]}</Request_Number>
              <Patient_Id type="string">#{params[:Patient_Id]}</Patient_Id>
              <Service_YM type="string">#{params[:Service_YM]}</Service_YM>
              <Service_Code_Kind type="string">#{params[:Service_Code_Kind]}</Service_Code_Kind>
              <Service_Information type="array">
                #{params[:Service_Information].present? ? build_service_information_xml(params[:Service_Information]) : ''}
              </Service_Information>
            </servicemodreq>
          </data>
        XML
      end

      def build_service_information_xml(service_information)
        service_information.map do |item|
          kasan_information_xml = build_kasan_information_xml(item[:Kasan_Information]) if item[:Kasan_Information].present?

          <<~XML
            <Service_Information_child type="record">
              <Service_Code_Kind type="string">#{item[:Service_Code_Kind]}</Service_Code_Kind>
              <Provider_Id type="string">#{item[:Provider_Id]}</Provider_Id>
              <Service_Code type="string">#{item[:Service_Code]}</Service_Code>
              <Service_Days type="string">#{item[:Service_Days]}</Service_Days>
              #{kasan_information_xml ? "<Kasan_Information type=\"array\">\n#{kasan_information_xml}\n</Kasan_Information>" : ''}
            </Service_Information_child>
          XML
        end.join("\n")
      end

      def build_kasan_information_xml(kasan_information)
        kasan_information.map do |kasan|
          <<~XML
            <Kasan_Information_child type="record">
              <Service_Code type="string">#{kasan[:Service_Code]}</Service_Code>
              <Service_Days type="string">#{kasan[:Service_Days]}</Service_Days>
            </Kasan_Information_child>
          XML
        end.join("\n")
      end
    end
  end
end

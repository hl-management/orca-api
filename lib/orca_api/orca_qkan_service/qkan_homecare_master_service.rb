module OrcaApi
  class OrcaQkanService < Service
    # 利用者向け請求書取得API
    class QkanHomecareMasterService < Service
      def get(target_date = "")
        orca_api.call(
          "/mst01/mservice_codelst",
          format: 'xml',
          body: <<-XML
              <data>
                <mservicecodelstreq type="record">
                  <Service_Code_Kind type="string">13</Service_Code_Kind>
                  <Target_Date type="string">#{target_date}</Target_Date>
                  <Kasan_Flag type="string">0</Kasan_Flag>
                  <Santei_Item_Information type="array">
                    <Santei_Item_Information_child type="record">
                      <Item_No type="string">1</Item_No>
                      <Search_Value type="string">1</Search_Value>
                    </Santei_Item_Information_child>
                    <Santei_Item_Information_child type="record">
                      <Item_No type="string">3</Item_No>
                      <Search_Value type="string">1</Search_Value>
                    </Santei_Item_Information_child>
                  </Santei_Item_Information>
                </mservicecodelstreq>
              </data>
          XML
        )
      end
    end
  end
end

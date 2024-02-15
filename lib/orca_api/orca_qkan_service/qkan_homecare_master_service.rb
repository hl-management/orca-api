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
                  <Service_Code_Kind type="string">13</System_Service_Kind_Detail>
                  <Target_Date type="string">#{target_date}</Target_Date>
                  <Kasan_Flag type="string">0</Kasan_Flag>
                  <Santei_Item_Information type="array">
                    <!-- 算定項目情報(施設等の区分) -->
                    <Santei_Item_Information_child type="record">
                        <!-- 10-1_算定項目番号 -->
                        <Item_No type="string">1</Item_No>
                        <!-- 10-2_算定項目検索値 -->
                        <Search_Value type="string">1</Search_Value>
                    </Santei_Item_Information_child>
                    <!-- 算定項目情報(職員区分) -->
                    <Santei_Item_Information_child type="record">
                        <!-- 10-1_算定項目番号 -->
                        <Item_No type="string">3</Item_No>
                        <!-- 10-2_算定項目検索値 -->
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

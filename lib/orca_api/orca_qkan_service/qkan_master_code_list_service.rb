module OrcaApi
  class OrcaQkanService < Service
    # 利用者向け請求書取得API
    class QkanMasterCodeListService < Service
      # @param target_date [String] 対象年月日
      # @param service_code_kind [String] 介護サービス種類コード
      # @param santei_item_information [Array<Hash>] 算定項目情報
      # @option santei_item_information :item_no 算定項目番号
      # @option santei_item_information :search_value 算定項目検索値
      def get(params)
        orca_api.call(
          "/mst01/mservice_codelst",
          format: 'xml',
          body: <<-XML
              <data>
                <mservicecodelstreq type='record'>
                  <Service_Code_Kind type='string'>#{params[:service_code_kind]}</Service_Code_Kind>
                  <Target_Date type='string'>#{params[:target_date]}</Target_Date>
                  <Kasan_Flag type='string'>0</Kasan_Flag>
                  <Santei_Item_Information type='array'>
                    #{params[:santei_item_information] ? santei_items_xml(params) : ''}
                  </Santei_Item_Information>
                </mservicecodelstreq>
              </data>
          XML
        )
      end

      private

      def santei_items_xml(params)
        params[:santei_item_information].map do |item|
          <<~XML
            <Santei_Item_Information_child type="record">
              <Item_No type="string">#{item[:item_no]}</Item_No>
              <Search_Value type="string">#{item[:search_value]}</Search_Value>
            </Santei_Item_Information_child>
          XML
        end.join("\n")
      end
    end
  end
end

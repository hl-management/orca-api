# frozen_string_literal: true

module OrcaApi
  class OrcaQkanService < Service
    # サービスコード一括取得API（複数検索条件・最大100件）
    class QkanMultiMasterCodeListService < Service
      # @param search_conditions [Array<Hash>] 検索条件の配列
      # @option search_conditions [String] :search_condition_key 検索条件区別用キー（必須）
      # @option search_conditions [String] :target_date 対象年月日
      # @option search_conditions [String] :service_code_kind 介護サービス種類コード
      # @option search_conditions [String] :flag 加算サービス取得
      # @option search_conditions [String] :service_code_item 介護サービス項目コード
      # @option search_conditions [String] :kasan_with_kihon_flag 加算基本サービス絞込み
      # @option search_conditions [String] :provider_id 事業所番号
      # @option search_conditions [Array<Hash>] :santei_item_information 算定項目情報（:item_no, :search_value）
      def get(search_conditions)
        orca_api.call(
          "/mst01/mservice_multi_codelst",
          format: 'xml',
          body: <<-XML
              <data>
                <mservicemulticodelstreq type='record'>
                  <Search_Condition_Information type='array'>
                    #{search_conditions.map { |cond| search_condition_child_xml(cond) }.join("\n")}
                  </Search_Condition_Information>
                </mservicemulticodelstreq>
              </data>
          XML
        )
      end

      private

      def search_condition_child_xml(cond)
        <<~XML
          <Search_Condition_Information_child type='record'>
            <Search_Condition_Key type='string'>#{cond[:search_condition_key]}</Search_Condition_Key>
            <Service_Code_Kind type='string'>#{cond[:service_code_kind]}</Service_Code_Kind>
            <Target_Date type='string'>#{cond[:target_date]}</Target_Date>
            <Kasan_Flag type='string'>#{cond[:flag]}</Kasan_Flag>
            <Service_Code_Item type='string'>#{cond[:service_code_item]}</Service_Code_Item>
            <Kasan_With_Kihon_Flag type='string'>#{cond[:kasan_with_kihon_flag]}</Kasan_With_Kihon_Flag>
            <Provider_Id type='string'>#{cond[:provider_id]}</Provider_Id>
            <Santei_Item_Information type='array'>
              #{santei_items_xml(cond) if cond[:santei_item_information]}
            </Santei_Item_Information>
          </Search_Condition_Information_child>
        XML
      end

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

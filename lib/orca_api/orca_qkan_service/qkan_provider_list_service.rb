module OrcaApi
  class OrcaQkanService < Service
    # 利用者向け請求書取得API
    class QkanProviderListService < Service
      # @param haishi_flag [Integer] システム日付時点で
      #   0：廃止事業所を含む
      #   1：廃止事業所を含めない
      def get(haishi_flag = nil)
        orca_api.call(
          "/provider01/providerlst",
          format: 'xml',
          body: <<-XML
              <data>
                <providerlstreq type="record">
                  <Provider_Id type="string"></Provider_Id>
                  <Haishi_Flag type="string">#{haishi_flag}</Haishi_Flag>
                </providerlstreq>
              </data>
          XML
        )
      end
    end
  end
end

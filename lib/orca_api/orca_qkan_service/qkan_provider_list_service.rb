module OrcaApi
  class OrcaQkanService < Service
    # 利用者向け請求書取得API
    class QkanProviderListService < Service
      def get
        orca_api.call(
          "/provider01/providerlst",
          format: 'xml',
          body: <<-XML
              <data>
                <providerlstreq type="record">
                  <Provider_Id type="string"></Provider_Id>
                </providerlstreq>
              </data>
          XML
        )
      end
    end
  end
end

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
                  <System_Service_Kind_Detail type="string">1111</System_Service_Kind_Detail>
                  <Target_Date type="string">#{target_date}</Target_Date>
                </mservicecodelstreq>
              </data>
          XML
        )
      end
    end
  end
end

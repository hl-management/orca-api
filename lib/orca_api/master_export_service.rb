require_relative "service"

module OrcaApi
  # マスタ取得実行リクエスト（Request_Number=01）
  #
  # @see https://www.orcamo.co.jp/api-council/members/standards/?haori_master_export
  class MasterExportService < Service
    def export(params)
      call("01", params)
    end

    def result(params)
      call("02", params)
    end

    private

    def call(request_number, params)
      params[:Request_Number] = request_number

      Result.new(orca_api.call("/orca51/masterexportv3", body: {
                                 "master_exportv3req" => params
                               }))
    end
  end
end

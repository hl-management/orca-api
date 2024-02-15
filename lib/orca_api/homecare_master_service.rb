# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  # API サービスコード取得
  class HomecareMasterService < Service
    def list(target_date = "")
      api_path = "/mst01/mservice_codelst"
      req_name = "mservicecodelstreq"

      body = {
        req_name => {
          "System_Service_Kind_Detail" => "1111",
          "Target_Date" => target_date,
        }
      }
      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

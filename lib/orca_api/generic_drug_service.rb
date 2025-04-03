# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  class GenericDrugService < Service
    def list(params)
      api_path = "/orca51/masterexportv3"
      req_name = "master_exportv3req"

      body = {
        req_name => {
          "Request_Number" => params[:request_number],
          "Karte_Uid" => params[:karte_uid],
          "Master_Id" => params[:master_id],
          "Base_Date" => params[:base_date],
          "Orca_Uid" => params[:orca_uid],
        }
      }
      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

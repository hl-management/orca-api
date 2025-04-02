# frozen_string_literal: true

require_relative 'service'

module OrcaApi
  class GenericDrugService < Service

    def list(params = { })
      api_path = "/orca51/masterexportv3"
      req_name = "masterexportv3"

      body = {
        req_name => params
      }
      Result.new(orca_api.call(api_path, body: body))
    end
  end
end

# spec/orca_api/qkan_service/qkan_provider_list_service_spec.rb
require "spec_helper"
require "orca_api/orca_qkan_service/qkan_master_code_list_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanMasterCodeListService do # rubocop:disable RSpec/FilePath
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: api_response) }
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    let(:api_response) do
      {
        success: true,
        response: load_orca_api_response("mst01_mservice_codelst.json")
        # Add other necessary keys based on the actual response structure
      }
    end

    it "returns the API response" do
      result = service.get

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end
end

# spec/orca_api/qkan_service/qkan_provider_list_service_spec.rb
require "spec_helper"
require "orca_api/orca_qkan_service/qkan_master_code_list_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanMasterCodeListService do # rubocop:disable Spec/SpecFilePathFormat
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
      santei_item_information = [{ item_no: '1', search_value: '1' }, { item_no: '3', search_value: '1' }]
      params = {
        target_date: '2024-02-15',
        service_code_kind: '13',
        santei_item_information: santei_item_information,
      }
      result = service.get(params)

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end
end

# spec/orca_api/qkan_service/qkan_multi_master_code_list_service_spec.rb
require "spec_helper"
require "orca_api/orca_qkan_service/qkan_multi_master_code_list_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanMultiMasterCodeListService do # rubocop:disable Spec/SpecFilePathFormat
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: api_response) }
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    let(:api_response) do
      {
        success: true,
        response: load_orca_api_response("mst01_mservice_multi_codelst.json")
      }
    end

    it "returns the API response" do
      search_conditions = [
        {
          search_condition_key: "13",
          target_date: "2026-03-19",
          service_code_kind: "13",
          flag: "1",
          provider_id: "1312345678"
        },
        {
          search_condition_key: "63",
          target_date: "2026-03-19",
          service_code_kind: "63",
          flag: "1",
          provider_id: "1312345678"
        }
      ]
      result = service.get(search_conditions)

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end
end

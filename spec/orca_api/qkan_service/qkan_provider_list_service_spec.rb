# spec/orca_api/qkan_service/qkan_provider_list_service_spec.rb
require "spec_helper"
require "orca_api/orca_qkan_service/qkan_provider_list_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanProviderListService do # rubocop:disable RSpec/SpecFilePathFormat, RSpec/FilePath
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: api_response) }
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    let(:api_response) do
      {
        success: true,
        response: load_orca_api_response("provider01_providerlst.json")
        # Add other necessary keys based on the actual response structure
      }
    end

    it "calls the correct API endpoint with the correct parameters" do
      expected_path = "/provider01/providerlst"
      expected_format = 'xml'
      expected_body = <<-XML
              <data>
                <providerlstreq type="record">
                  <Provider_Id type="string"></Provider_Id>
                </providerlstreq>
              </data>
      XML

      expect(orca_api).to receive(:call).
        with(expected_path, format: expected_format, body: match(/#{Regexp.escape(expected_body)}/))

      service.get
    end

    it "returns the API response" do
      result = service.get

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end
end

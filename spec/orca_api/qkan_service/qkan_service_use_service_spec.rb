require "spec_helper"
require "orca_api/orca_qkan_service/qkan_service_use_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanServiceUseService do # rubocop:disable RSpec/SpecFilePathFormat
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: api_response) }
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    let(:api_response) do
      {
        success: true,
        response: "処理終了"
      }
    end

    it "calls the 予定・実績情報取得API endpoint with the patient id and service month" do
      expect(orca_api).to receive(:call).with(
        "/service01/serviceinf",
        format: 'xml',
        body: include('<serviceinfreq type="record">').
              and(include('<Patient_Id type="string">12345</Patient_Id>')).
              and(include('<Service_YM type="string">2026-05</Service_YM>'))
      )

      service.get("12345", "2026-05")
    end

    it "returns the API response" do
      result = service.get("12345", "2026-05")

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end
end

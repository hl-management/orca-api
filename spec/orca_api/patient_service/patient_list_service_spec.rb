require "spec_helper"
require_relative "../shared_examples"

RSpec.describe OrcaApi::PatientService::PatientListService, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }
  let(:response_data) { parse_json(response_json) }

  describe "#list" do
    subject { service.list('2023-01-01', '2024-01-01', '01') }

    before do
      expect(orca_api).to receive(:call).exactly(1) do |path|
        expect(path).to eq("/api01rv2/patientlst1v2?class=01")
        response_json
      end
    end

    context "正常系" do
      let(:response_json) { load_orca_api_response("api01rv2_patientlst1v2.json") }

      its("ok?") { is_expected.to be(true) }
    end
  end
end

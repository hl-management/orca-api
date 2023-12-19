require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::MedicationMasterListService, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }
  let(:response_data) { parse_json(response_json) }

  describe "#list" do
    subject { service.list(args) }

    before do
      expect(orca_api).to receive(:call).exactly(1) do |path|
        expect(path).to eq("/orca51/medicationmasterlstv3")
        response_json
      end
    end

    context "正常系" do
      let(:response_json) { load_orca_api_response("orca51_medicationmasterlstv3_01.json") }
      let(:args) do
        its("ok?") { is_expected.to be(true) }
      end
    end

    context "異常系" do
      let(:response_json) { load_orca_api_response("orca51_medicationmasterlstv3_01_E04.json") }
      let(:args) { {} }

      its("ok?") { is_expected.to be(false) }
    end
  end
end

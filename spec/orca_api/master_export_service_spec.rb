require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::MasterExportService, orca_api_mock: true do
  let(:service) { describe_class.new(orca_api) }
  let(:response_data) { parse_json(response_json) }

  before do
    expect(orca_api).to receive(:call).exactly(1) do |path|
      expect(path).to eq("/orca51/masterexportv3")
      response_json
    end
  end

  describe '#export' do
    subject { service.export(args) }

    context "success" do
      let(:response_json) { load_orca_api_response("orca51_masterexportv3_export_01.json") }

      let(:args) do
        {
          Karte_Uid: "cab05420-f855-4e25-bfe1-5f088456c1cd",
          Master_Id: 'tbl_byomei',
          Base_Date: '2018-04-01',
        }

      its("ok?") { is_expected.to be(true) }
    end
  end

  describe "#result" do
    subject { service.result(args) }

    context "success" do
      let(:response_json) { load_orca_api_response("orca51_masterexportv3_result_01.json") }
      let(:args) do
        {
          Karte_Uid: "210983b4-2d9f-4daf-af0e-b8b76b1703e9",
          Orca_Uid: "2528b7da-bce4-44f1-a474-8101772c27b0"
        }

        its("ok?") { is_expected.to be(true) }
      end
    end
  end

end

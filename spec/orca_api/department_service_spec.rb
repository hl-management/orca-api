require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::DepartmentService, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }
  let(:response_data) { parse_json(response_json) }

  describe "#list" do
    let(:response_json) { load_orca_api_response("api01rv2_system01lstv2_01.json") }

    before do
      body = {
        "system01_managereq" => {
          "Request_Number" => "01",
          "Base_Date" => base_date,
        }
      }
      expect(orca_api).to receive(:call).with("/api01rv2/system01lstv2", body: body).once.and_return(response_json)
    end

    shared_examples "結果が正しいこと" do
      its("ok?") { is_expected.to be true }
      its(:department_information) { is_expected.to eq(response_data.first[1]["Department_Information"]) }
    end

    context "引数を省略する" do
      subject { service.list }

      let(:base_date) { "" }

      include_examples "結果が正しいこと"
    end

    context "base_date引数を指定する" do
      subject { service.list(base_date) }

      let(:base_date) { "2017-07-25" }

      include_examples "結果が正しいこと"
    end
  end
end

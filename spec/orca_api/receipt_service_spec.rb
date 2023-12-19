require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::ReceiptService, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }
  let(:orca_uid) { "c585dc3e-fa42-4f45-b02f-5a4166d0721d" }
  let(:response_data) { parse_json(response_json) }

  describe "レセプト作成" do
    let(:args) {
      {
        "Perform_Date" => "",
        "Perform_Month" => "2017-11",
        "InOut" => "O",
        "Receipt_Mode" => "All",
        "Print_Mode" => "Check",
        "Submission_Mode" => "01",
        "Patient_Information" => [],
      }
    }

    before do
      count = 0
      prev_response_json = nil
      expect(orca_api).to receive(:call).exactly(1) { |path, body:|
        count += 1
        prev_response_json =
          case count
          when 1
            aggregate_failures "リクエスト内容のチェック" do
              expect(path).to eq("/orca42/receiptmakev3")

              req = body["receipt_makev3req"]
              expect(req["Request_Number"]).to eq(request_number)
              expect(req["Karte_Uid"]).to eq(orca_api.karte_uid)
              expect(req["Orca_Uid"]).to eq(expected_orca_uid)
              %w(
                Perform_Date
                Perform_Month
                InOut
                Receipt_Mode
                Print_Mode
                Submission_Mode
                Patient_Information
              ).each do |name|
                expect(req[name]).to eq(args[name])
              end
            end

            response_json
          end
        prev_response_json
      }
    end

    describe "#create" do
      subject { service.create(args) }

      let(:request_number) { "01" }
      let(:expected_orca_uid) { "" }

      context "正常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptmakev3_01.json") }

        its("ok?") { is_expected.to be(true) }
        its(["Response_Number"]) { is_expected.to eq("02") }
        its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }
      end

      context "異常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptmakev3_01_E13.json") }

        its("ok?") { is_expected.to be(false) }
      end
    end

    describe "#created" do
      subject { service.created(args) }

      let(:request_number) { "02" }
      let(:expected_orca_uid) { orca_uid }
      let(:args) { super().merge("Orca_Uid" => orca_uid) }

      context "正常系" do
        context "処理中" do
          let(:response_json) { load_orca_api_response("orca42_receiptmakev3_02_E70.json") }

          its("ok?") { is_expected.to be(false) }
          its("doing?") { is_expected.to be(true) }
          its(["Response_Number"]) { is_expected.to eq("01") }
          its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }
        end

        context "完了" do
          let(:response_json) { load_orca_api_response("orca42_receiptmakev3_02.json") }

          its("ok?") { is_expected.to be(true) }
          its("doing?") { is_expected.to be(false) }
          its(["Response_Number"]) { is_expected.to eq("02") }
          its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }

          %w(
            All_Count
            All_Number_Of_Sheets
            Receipt_Information
          ).each do |name|
            its([name]) { is_expected.to eq(response_data.first[1][name]) }
          end
        end
      end

      context "異常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptmakev3_02_E41.json") }

        its("ok?") { is_expected.to be(false) }
      end
    end
  end

  describe "レセプト印刷" do
    let(:receipt_information) {
      OrcaApi::Result.new(load_orca_api_response("orca42_receiptmakev3_02.json"))["Receipt_Information"]
    }
    let(:args) {
      {
        "Orca_Uid" => orca_uid,
        "Perform_Date" => "",
        "Perform_Month" => "2017-11",
        "InOut" => "O",
        "Receipt_Mode" => "All",
        "Print_Mode" => "All",
        "Submission_Mode" => "01",
        "Receipt_Information" => receipt_information,
      }
    }

    before do
      count = 0
      prev_response_json = nil
      expect(orca_api).to receive(:call).exactly(1) { |path, body:|
        count += 1
        prev_response_json =
          case count
          when 1
            aggregate_failures "リクエスト内容のチェック" do
              expect(path).to eq("/orca42/receiptprintv3")

              req = body["receipt_printv3req"]
              expect(req["Request_Number"]).to eq(request_number)
              expect(req["Karte_Uid"]).to eq(orca_api.karte_uid)
              %w(
                Orca_Uid
                Perform_Date
                Perform_Month
                InOut
                Receipt_Mode
                Print_Mode
                Submission_Mode
                Receipt_Information
              ).each do |name|
                expect(req[name]).to eq(args[name])
              end
            end

            response_json
          end
        prev_response_json
      }
    end

    describe "#print" do
      subject { service.print(args) }

      let(:request_number) { "01" }

      context "正常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptprintv3_01.json") }

        its("ok?") { is_expected.to be(true) }
        its(["Response_Number"]) { is_expected.to eq("02") }
        its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }

        %w(
          Data_Id_Information
        ).each do |name|
          its([name]) { is_expected.to eq(response_data.first[1][name]) }
        end
      end

      context "異常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptprintv3_01_E42.json") }

        its("ok?") { is_expected.to be(false) }
      end
    end

    describe "#printed" do
      subject { service.printed(args) }

      let(:request_number) { "02" }

      context "正常系" do
        context "処理中" do
          let(:response_json) { load_orca_api_response("orca42_receiptprintv3_02_E70.json") }

          its("ok?") { is_expected.to be(false) }
          its("doing?") { is_expected.to be(true) }
          its(["Response_Number"]) { is_expected.to eq("01") }
          its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }
        end

        context "完了" do
          let(:response_json) { load_orca_api_response("orca42_receiptprintv3_02.json") }

          its("ok?") { is_expected.to be(true) }
          its("doing?") { is_expected.to be(false) }
          its(["Response_Number"]) { is_expected.to eq("02") }
          its(["Orca_Uid"]) { is_expected.to eq(orca_uid) }

          %w(
            All_Number_Of_Sheets
          ).each do |name|
            its([name]) { is_expected.to eq(response_data.first[1][name]) }
          end
        end
      end

      context "異常系" do
        let(:response_json) { load_orca_api_response("orca42_receiptprintv3_02_E42.json") }

        its("ok?") { is_expected.to be(false) }
      end
    end
  end
end

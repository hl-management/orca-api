# -*- coding: utf-8 -*-

require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::IncomeService, orca_api_mock: true do
  let(:service) { described_class.new(orca_api) }

  def expect_orca23_incomev3_01(path, body, mode, args, response_json)
    expect(path).to eq(OrcaApi::IncomeService::PATH)

    req = body[OrcaApi::IncomeService::REQUEST_NAME]
    expect(req["Request_Number"]).to eq("01")
    expect(req["Request_Mode"]).to eq(mode)
    expect(req["Karte_Uid"]).to eq(orca_api.karte_uid)
    expect(req["Orca_Uid"]).to be_nil

    attr_names = case mode
                 when "01"
                   %w(
                     Patient_ID
                     Information_Class
                     Start_Date
                     End_Date
                     Start_Month
                     End_Month
                     Sort_Key
                   )
                 when "02"
                   %w(
                   )
                 else
                   raise "invalid mode: #{mode}"
                 end
    attr_names.each do |attr_name|
      expect(req[attr_name]).to eq(args[attr_name])
    end

    return_response_json(response_json)
  end

  def expect_orca23_incomev3_02(path, body, mode, args, prev_response_json, response_json)
    expect(path).to eq(OrcaApi::IncomeService::PATH)

    req = body[OrcaApi::IncomeService::REQUEST_NAME]
    res_body = prev_response_json.first[1]
    expect(req["Request_Number"]).to eq("02")
    expect(req["Request_Mode"]).to eq(mode)
    expect(req["Karte_Uid"]).to eq(orca_api.karte_uid)
    expect(req["Orca_Uid"]).to eq(res_body["Orca_Uid"])
    expect(req["Patient_ID"]).to eq(res_body["Patient_ID"])

    if (income_detail = res_body["Income_Detail"])
      expect(req["InOut"]).to eq(income_detail["InOut"])
      expect(req["Invoice_Number"]).to eq(income_detail["Invoice_Number"])
    end

    attr_names = case mode
                 when "01"
                   %w(
                   )
                 when "02"
                   %w(
                   )
                 when "03"
                   %w(
                   )
                 when "04"
                   %w(
                   )
                 when "05"
                   %w(
                   )
                 when "06"
                   %w(
                   )
                 when "07"
                   %w(
                   )
                 when "08"
                   %w(
                   )
                 else
                   raise "invalid mode: #{mode}"
                 end
    attr_names.each do |attr_name|
      expect(req[attr_name]).to eq(args[attr_name])
    end

    return_response_json(response_json)
  end

  def expect_orca23_incomev3_99(path, body, prev_response_json)
    expect(path).to eq(OrcaApi::IncomeService::PATH)

    req = body[OrcaApi::IncomeService::REQUEST_NAME]
    res_body = prev_response_json.first[1]
    expect(req["Request_Number"]).to eq("99")
    expect(req["Karte_Uid"]).to eq(orca_api.karte_uid)
    expect(req["Orca_Uid"]).to eq(res_body["Orca_Uid"])

    load_orca_api_response_json("orca23_incomev3_99.json")
  end

  describe "#list" do
    let(:start_date) { "" }
    let(:start_month) { "" }
    let(:args) {
      {
        "Patient_ID" => "1",
        "Information_Class" => information_class,
        "Start_Date" => start_date,
        "End_Date" => "",
        "Start_Month" => start_month,
        "End_Month" => "",
        "Sort_Key" => {
          "Key_Class" => "",
          "Order_Class" => "",
        }
      }
    }

    subject { service.list(args) }

    context "ロックを伴う" do
      before do
        count = 0
        prev_response_json = nil
        expect(orca_api).to receive(:call).exactly(2) { |path, body:|
          count += 1
          prev_response_json =
            case count
            when 1
              expect_orca23_incomev3_01(path, body, "01", args, response_json)
            when 2
              expect_orca23_incomev3_99(path, body, prev_response_json)
            end
          prev_response_json
        }
      end

      context "正常系" do
        shared_examples "結果が正しいこと" do
          its("ok?") { is_expected.to be true }

          %w(
            Income_Information
            Unpaid_Money_Total_Information
          ).each do |json_name|
            its([json_name]) { is_expected.to eq(response_json.first[1][json_name]) }
          end
        end

        context "Information_Class = 1:指定した期間内の請求一覧" do
          let(:information_class) { "1" }
          let(:start_month) { "2012-01" }
          let(:response_json) { load_orca_api_response_json("orca23_incomev3_01_01_information_class_1.json") }

          include_examples "結果が正しいこと"
        end

        context "Information_Class = 2:指定した期間内の未収（過入）金のある請求一覧" do
          let(:information_class) { "2" }
          let(:start_month) { "2012-01" }
          let(:response_json) { load_orca_api_response_json("orca23_incomev3_01_01_information_class_2.json") }

          include_examples "結果が正しいこと"
        end

        context "Information_Class = 3:指定した期間内に入返金が行われた請求一覧" do
          let(:information_class) { "2" }
          let(:start_date) { "2012-01-01" }
          let(:response_json) { load_orca_api_response_json("orca23_incomev3_01_01_information_class_3.json") }

          include_examples "結果が正しいこと"
        end
      end

      context "異常系" do
        context "エラー" do
          let(:information_class) { "1" }
          let(:start_month) { "2012-01" }
          let(:response_json) { load_orca_api_response_json("orca23_incomev3_01_01_E0072.json") }

          its("ok?") { is_expected.to be false }
        end
      end
    end

    context "ロックを伴わない" do
      before do
        count = 0
        prev_response_json = nil
        expect(orca_api).to receive(:call).exactly(1) { |path, body:|
          count += 1
          prev_response_json =
            case count
            when 1
              expect_orca23_incomev3_01(path, body, "01", args, response_json)
            end
          prev_response_json
        }
      end

      context "異常系" do
        context "他端末使用中" do
          let(:information_class) { "1" }
          let(:start_month) { "2012-01" }
          let(:response_json) { load_orca_api_response_json("orca23_incomev3_01_01_E9999.json") }

          its("ok?") { is_expected.to be false }
        end
      end
    end
  end
end

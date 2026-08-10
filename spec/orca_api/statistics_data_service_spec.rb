require "spec_helper"
require_relative "shared_examples"

RSpec.describe OrcaApi::StatisticsDataService, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }

  describe "#list" do
    it "calls the API correctly" do
      expect_orca_api_call(
        [
          {
            path: "/orca07/statisticsdatav3",
            body: {
              statistics_datav3req: {
                "Request_Number" => "00",
                "Karte_Uid" => orca_api.karte_uid,
                "Statistics_Mode" => "Monthly"
              }
            },
            response: {
              "statistics_datav3res" => {
                "Api_Result" => "000",
                "Api_Result_Message" => "情報取得終了",
                "Statistics_Data_List_Information" => [
                  {
                    "Statistics_Group_No" => "20260529165253",
                    "Statistics_Processing_Number" => "0001",
                    "Statistics_Serial_Number" => "0001",
                    "Statistics_Character_Code" => "Shift_JIS",
                    "Statistics_File_Name" => "01shinryoutensugekkei_202605.csv",
                    "Statistics_Output_Count" => "00006",
                    "Statistics_Data_Title" => "保険別診療点数月計表",
                    "Statistics_Create_Date" => "2026-05-29"
                  }
                ]
              }
            }.to_json
          }
        ],
        binding
      )

      result = service.list mode: :monthly
      expect(result.ok?).to be true
      first_entry = result.body["Statistics_Data_List_Information"].first
      expect(first_entry["Statistics_File_Name"]).to eq("01shinryoutensugekkei_202605.csv")
    end

    it "raises for an unsupported mode" do
      expect {
        service.list mode: :yearly
      }.to raise_error ArgumentError
    end
  end

  describe "#get" do
    it "calls the API correctly" do
      data_info = {
        "Statistics_Group_No" => "20260529165253",
        "Statistics_Processing_Number" => "0001",
        "Statistics_Serial_Number" => "0001",
        "Statistics_Character_Code" => "Shift_JIS",
        "Statistics_File_Name" => "01shinryoutensugekkei_202605.csv"
      }

      expect_orca_api_call(
        [
          {
            path: "/orca07/statisticsdatav3",
            body: {
              statistics_datav3req: {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Statistics_Mode" => "Monthly",
                "Statistics_Data_Information" => {
                  "Statistics_Group_No" => "20260529165253",
                  "Statistics_Processing_Number" => "0001",
                  "Statistics_Serial_Number" => "0001",
                  "Statistics_Character_Code" => "Shift_JIS",
                  "Statistics_File_Name" => "01shinryoutensugekkei_202605.csv"
                }
              }
            },
            response: {
              "statistics_datav3res" => {
                "Api_Result" => "000",
                "Api_Result_Message" => "情報取得終了",
                "Data_Id_Information" => [
                  { "Data_Id" => "blob:abc" }
                ]
              }
            }.to_json
          }
        ],
        binding
      )

      result = service.get data_info, mode: :monthly
      expect(result.ok?).to be true
      expect(result.body["Data_Id_Information"].first["Data_Id"]).to eq("blob:abc")
    end

    it "sends Statistics_Mode from the given mode" do
      data_info = {
        "Statistics_Group_No" => "20260529165253",
        "Statistics_Processing_Number" => "0001",
        "Statistics_Serial_Number" => "0001",
        "Statistics_Character_Code" => "Shift_JIS",
        "Statistics_File_Name" => "01shinryoutensugekkei_202605.csv"
      }

      expect_orca_api_call(
        [
          {
            path: "/orca07/statisticsdatav3",
            body: {
              statistics_datav3req: {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Statistics_Mode" => "Daily",
                "Statistics_Data_Information" => {
                  "Statistics_Group_No" => "20260529165253",
                  "Statistics_Processing_Number" => "0001",
                  "Statistics_Serial_Number" => "0001",
                  "Statistics_Character_Code" => "Shift_JIS",
                  "Statistics_File_Name" => "01shinryoutensugekkei_202605.csv"
                }
              }
            },
            response: {
              "statistics_datav3res" => {
                "Api_Result" => "000",
                "Api_Result_Message" => "情報取得終了",
                "Data_Id_Information" => [
                  { "Data_Id" => "blob:abc" }
                ]
              }
            }.to_json
          }
        ],
        binding
      )

      result = service.get data_info, mode: :daily
      expect(result.ok?).to be true
      expect(result.body["Data_Id_Information"].first["Data_Id"]).to eq("blob:abc")
    end

    it "raises for an unsupported mode" do
      expect {
        service.get({}, mode: :yearly)
      }.to raise_error ArgumentError
    end
  end
end

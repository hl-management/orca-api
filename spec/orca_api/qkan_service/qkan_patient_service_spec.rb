require "spec_helper"
require "orca_api/orca_qkan_service/qkan_patient_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanPatientService do # rubocop:disable RSpec/SpecFilePathFormat
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: api_response) }
  let(:service) { described_class.new(orca_api) }

  describe "#create" do
    let(:api_response) do
      {
        success: true,
        response: load_orca_api_response("patient01_patientadd.json")
        # Add other necessary keys based on the actual response structure
      }
    end

    it "calls the correct API endpoint with the correct parameters" do
      params = {
        gender: 1,
        last_name: "検証１",
        first_name: "検証１",
        last_kana_name: "テス",
        first_kana_name: "ト",
        birthday: '1991-12-12',
        orca_patient_no: '0000'
      }

      expect(orca_api).to receive(:call).with(
        "/patient01/patientadd",
        format: 'xml',
        body: match(/Patient_Family_Name.*検証１.*Patient_Code.*0000/m)
      )

      service.create(params)
    end

    it "includes nintei_history_information when provided" do
      params = {
        gender: 1,
        last_name: "検証１",
        first_name: "検証１",
        last_kana_name: "テス",
        first_kana_name: "ト",
        birthday: '1991-12-12',
        orca_patient_no: '0000',
        nintei_history_information: [
          {
            insurer_id: 123456,
            insured_id: "0000000001",
            insure_rate: 10,
            planner: "ケアマネ太郎",
            provider_id: "1234567890",
            shubetsu_code: 1,
            change_code: 2,
            jotai_code: "21",
            insure_valid_start: "2024-01-01",
            insure_valid_end: "2024-12-31",
            nintei_date: "2024-01-15"
          }
        ]
      }

      expect(orca_api).to receive(:call).with(
        "/patient01/patientadd",
        format: 'xml',
        body: match(/Insurer_Id.*123456.*Insured_Id.*0000000001.*Insure_Rate.*10.*Planner.*ケアマネ太郎.*Provider_Id.*1234567890.*Shubetsu_Code.*1.*Change_Code.*2.*Jotai_Code.*21.*Insure_Valid_Start.*2024-01-01.*Insure_Valid_End.*2024-12-31.*Nintei_Date.*2024-01-15/m)
      )

      service.create(params)
    end

    it "returns the API response" do
      params = {
        gender: 1,
        last_name: "検証１",
        first_name: "検証１",
        last_kana_name: "テス",
        first_kana_name: "ト",
        birthday: '1991-12-12',
      }
      result = service.create(params)

      expect(result[:success]).to be true
      expect(result[:response]).to include("処理終了")
    end
  end

  describe "#create_nintei_history" do
    let(:api_response) do
      {
        success: true,
        response: "処理終了"
      }
    end

    it "calls the correct API endpoint" do
      patient_id = "12345"
      nintei_histories = [{
        insurer_id: 123456,
        insured_id: "0000000001",
        insure_rate: 10,
        jotai_code: "21",
        insure_valid_start: "2024-01-01",
        insure_valid_end: "2024-12-31"
      }]

      expect(orca_api).to receive(:call).with(
        "/patient01/nintei_historymod",
        format: 'xml',
        body: match(/Request_Number.*01.*Patient_Id.*12345.*Insurer_Id.*123456.*Insured_Id.*0000000001.*Insure_Rate.*10.*Jotai_Code.*21/m)
      )

      service.create_nintei_history(patient_id, nintei_histories)
    end
  end

  describe "#update_nintei_history" do
    let(:api_response) do
      {
        success: true,
        response: "処理終了"
      }
    end

    it "calls the correct API endpoint" do
      nintei_histories = [{
        update_key: "key123",
        insurer_id: 123456,
        insured_id: "0000000001",
        jotai_code: "22",
        insure_valid_end: "2025-12-31"
      }]

      expect(orca_api).to receive(:call).with(
        "/patient01/nintei_historymod",
        format: 'xml',
        body: match(/Request_Number.*02.*Update_Key.*key123.*Insurer_Id.*123456.*Insured_Id.*0000000001.*Jotai_Code.*22/m)
      )

      service.update_nintei_history(nintei_histories)
    end
  end

  describe "#delete_nintei_history" do
    let(:api_response) do
      {
        success: true,
        response: "処理終了"
      }
    end

    it "calls the correct API endpoint" do
      update_keys = ["key123", "key456"]

      expect(orca_api).to receive(:call).with(
        "/patient01/nintei_historymod",
        format: 'xml',
        body: match(/Request_Number.*03.*Update_Key.*key123.*Update_Key.*key456/m)
      )

      service.delete_nintei_history(update_keys)
    end
  end
end

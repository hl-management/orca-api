require "spec_helper"
require "orca_api/orca_qkan_service/qkan_patient_service"

RSpec.describe OrcaApi::OrcaQkanService::QkanPatientService do # rubocop:disable RSpec/SpecFilePathFormat
  # rubocop:disable RSpec/LeakyLocalVariable
  orca_model = 'OrcaApi::Api'
  # rubocop:enable RSpec/LeakyLocalVariable
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
          { insurer_id: 123456, insured_id: "0000000001" }
        ]
      }

      expect(orca_api).to receive(:call).with(
        "/patient01/patientadd",
        format: 'xml',
        body: match(/PatientNinteiHistory_Information.*Insurer_Id.*123456.*Insured_Id.*0000000001/m)
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
      nintei_histories = [{ insurer_id: 123456, insured_id: "0000000001" }]

      expect(orca_api).to receive(:call).with(
        "/patient01/nintei_historymod",
        format: 'xml',
        body: match(/Request_Number.*01.*Patient_Id.*#{patient_id}/m)
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
      nintei_histories = [{ update_key: "key123", insurer_id: 123456 }]

      expect(orca_api).to receive(:call).with(
        "/patient01/nintei_historymod",
        format: 'xml',
        body: match(/Request_Number.*02/m)
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

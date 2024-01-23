# spec/orca_api/qkan_service/qkan_provider_list_service_spec.rb
require "spec_helper"
require "orca_api/orca_qkan_service/patient_qkan_service"

RSpec.describe OrcaApi::OrcaQkanService::PatientQkanService do # rubocop:disable RSpec/FilePath, RSpec/SpecFilePathFormat
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
      }
      expected_path = "/patient01/patientadd"
      expected_format = 'xml'
      expected_body = <<-XML
          <data>
            <patientaddreq type="record">
              <Patient_Family_Name type="string">#{params[:last_name]}</Patient_Family_Name>
              <Patient_First_Name type="string">#{params[:first_name]}</Patient_First_Name>
              <Patient_Family_Kana type="string">#{params[:last_kana_name]}</Patient_Family_Kana>
              <Patient_First_Kana type="string">#{params[:first_kana_name]}</Patient_First_Kana>
              <Patient_Sex type="string">#{params[:gender]}</Patient_Sex>
              <Patient_Birthday type="string">#{params[:birthday]}</Patient_Birthday>
            </patientaddreq>
          </data>
      XML

      expect(orca_api).to receive(:call).
        with(expected_path, format: expected_format, body: match(/#{Regexp.escape(expected_body)}/))

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
end

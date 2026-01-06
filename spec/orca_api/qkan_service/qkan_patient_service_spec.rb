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
      expected_path = "/patient01/patientadd"
      expected_format = 'xml'
      expected_body = <<-XML
              <Patient_Family_Name type="string">検証１</Patient_Family_Name>
              <Patient_First_Name type="string">検証１</Patient_First_Name>
              <Patient_Family_Kana type="string">テス</Patient_Family_Kana>
              <Patient_First_Kana type="string">ト</Patient_First_Kana>
              <Patient_Sex type="string">1</Patient_Sex>
              <Patient_Birthday type="string">1991-12-12</Patient_Birthday>
              <Patient_Code type="string">0000</Patient_Code>
      XML

      params = {
        gender: 1,
        last_name: "検証１",
        first_name: "検証１",
        last_kana_name: "テス",
        first_kana_name: "ト",
        birthday: '1991-12-12',
        orca_patient_no: '0000'
      }

      expect(orca_api).to receive(:call).
        with(expected_path, format: expected_format, body: match(/#{Regexp.escape(expected_body)}/))

      service.create(params)
    end

    it "includes nintei_history_information when provided" do
      expected_path = "/patient01/patientadd"
      expected_format = 'xml'
      expected_body = <<-XML
                  <Insurer_Id type="integer">123456</Insurer_Id>
                  <Insured_Id type="string">0000000001</Insured_Id>
                  <Insure_Rate type="integer">10</Insure_Rate>
                  <Planner type="string">ケアマネ太郎</Planner>
                  <Provider_Id type="string">1234567890</Provider_Id>
                  <Shubetsu_Code type="integer">1</Shubetsu_Code>
                  <Change_Code type="integer">2</Change_Code>
                  <Jotai_Code type="string">21</Jotai_Code>
                  <Insure_Valid_Start type="string">2024-01-01</Insure_Valid_Start>
                  <Insure_Valid_End type="string">2024-12-31</Insure_Valid_End>
                  <System_Insure_Valid_Start type="string">2024-01-01</System_Insure_Valid_Start>
                  <System_Insure_Valid_End type="string">2024-12-31</System_Insure_Valid_End>
                  <Shinsei_Date type="string">2024-01-10</Shinsei_Date>
                  <Nintei_Date type="string">2024-01-15</Nintei_Date>
                  <Stop_Date type="string">2024-12-31</Stop_Date>
                  <Stop_Reason type="integer">1</Stop_Reason>
                  <Reported_Date type="string">2024-01-20</Reported_Date>
                  <Shortstay_Use_Init_Count type="integer">5</Shortstay_Use_Init_Count>
                  <Limit_Change_Flag type="integer">0</Limit_Change_Flag>
      XML

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
            system_insure_valid_start: "2024-01-01",
            system_insure_valid_end: "2024-12-31",
            shinsei_date: "2024-01-10",
            nintei_date: "2024-01-15",
            stop_date: "2024-12-31",
            stop_reason: 1,
            reported_date: "2024-01-20",
            shortstay_use_init_count: 5,
            limit_change_flag: 0
          }
        ]
      }

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

  describe "#create_nintei_history" do
    let(:api_response) do
      {
        success: true,
        response: "処理終了"
      }
    end

    it "calls the correct API endpoint" do
      expected_path = "/patient01/nintei_historymod"
      expected_format = 'xml'
      expected_body = <<-XML
              <Request_Number type="string">01</Request_Number>
              <Patient_Id type="string">12345</Patient_Id>
      XML
      expected_nintei = <<-XML
                  <Insurer_Id type="integer">123456</Insurer_Id>
                  <Insured_Id type="string">0000000001</Insured_Id>
                  <Insure_Rate type="integer">10</Insure_Rate>
                  <Planner type="string">ケアマネ太郎</Planner>
                  <Provider_Id type="string">1234567890</Provider_Id>
                  <Shubetsu_Code type="integer">1</Shubetsu_Code>
                  <Change_Code type="integer">2</Change_Code>
                  <Jotai_Code type="string">21</Jotai_Code>
                  <Insure_Valid_Start type="string">2024-01-01</Insure_Valid_Start>
                  <Insure_Valid_End type="string">2024-12-31</Insure_Valid_End>
                  <System_Insure_Valid_Start type="string">2024-01-01</System_Insure_Valid_Start>
                  <System_Insure_Valid_End type="string">2024-12-31</System_Insure_Valid_End>
                  <Shinsei_Date type="string">2024-01-10</Shinsei_Date>
                  <Nintei_Date type="string">2024-01-15</Nintei_Date>
                  <Stop_Date type="string">2024-12-31</Stop_Date>
                  <Stop_Reason type="integer">1</Stop_Reason>
                  <Reported_Date type="string">2024-01-20</Reported_Date>
                  <Shortstay_Use_Init_Count type="integer">5</Shortstay_Use_Init_Count>
                  <Limit_Change_Flag type="integer">0</Limit_Change_Flag>
      XML

      patient_id = "12345"
      nintei_histories = [{
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
        system_insure_valid_start: "2024-01-01",
        system_insure_valid_end: "2024-12-31",
        shinsei_date: "2024-01-10",
        nintei_date: "2024-01-15",
        stop_date: "2024-12-31",
        stop_reason: 1,
        reported_date: "2024-01-20",
        shortstay_use_init_count: 5,
        limit_change_flag: 0
      }]

      expect(orca_api).to receive(:call).
        with(expected_path,
             format: expected_format,
             body: match(/#{Regexp.escape(expected_body)}/).and(match(/#{Regexp.escape(expected_nintei)}/)))

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
      expected_path = "/patient01/nintei_historymod"
      expected_format = 'xml'
      expected_body = <<-XML
              <Request_Number type="string">02</Request_Number>
      XML
      expected_nintei = <<-XML
                  <Update_Key type="string">key123</Update_Key>
                  <Insurer_Id type="integer">123456</Insurer_Id>
                  <Insured_Id type="string">0000000001</Insured_Id>
                  <Insure_Rate type="integer">10</Insure_Rate>
                  <Planner type="string">ケアマネ太郎</Planner>
                  <Provider_Id type="string">1234567890</Provider_Id>
                  <Shubetsu_Code type="integer">1</Shubetsu_Code>
                  <Change_Code type="integer">2</Change_Code>
                  <Jotai_Code type="string">22</Jotai_Code>
                  <Insure_Valid_Start type="string">2024-01-01</Insure_Valid_Start>
                  <Insure_Valid_End type="string">2025-12-31</Insure_Valid_End>
                  <System_Insure_Valid_Start type="string">2024-01-01</System_Insure_Valid_Start>
                  <System_Insure_Valid_End type="string">2025-12-31</System_Insure_Valid_End>
                  <Shinsei_Date type="string">2024-01-10</Shinsei_Date>
                  <Nintei_Date type="string">2024-01-15</Nintei_Date>
                  <Stop_Date type="string">2025-12-31</Stop_Date>
                  <Stop_Reason type="integer">2</Stop_Reason>
                  <Reported_Date type="string">2024-01-20</Reported_Date>
                  <Shortstay_Use_Init_Count type="integer">10</Shortstay_Use_Init_Count>
                  <Limit_Change_Flag type="integer">1</Limit_Change_Flag>
      XML

      nintei_histories = [{
        update_key: "key123",
        insurer_id: 123456,
        insured_id: "0000000001",
        insure_rate: 10,
        planner: "ケアマネ太郎",
        provider_id: "1234567890",
        shubetsu_code: 1,
        change_code: 2,
        jotai_code: "22",
        insure_valid_start: "2024-01-01",
        insure_valid_end: "2025-12-31",
        system_insure_valid_start: "2024-01-01",
        system_insure_valid_end: "2025-12-31",
        shinsei_date: "2024-01-10",
        nintei_date: "2024-01-15",
        stop_date: "2025-12-31",
        stop_reason: 2,
        reported_date: "2024-01-20",
        shortstay_use_init_count: 10,
        limit_change_flag: 1
      }]

      expect(orca_api).to receive(:call).
        with(expected_path,
             format: expected_format,
             body: match(/#{Regexp.escape(expected_body)}/).and(match(/#{Regexp.escape(expected_nintei)}/)))

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
      expected_path = "/patient01/nintei_historymod"
      expected_format = 'xml'
      expected_body = <<-XML
              <Request_Number type="string">03</Request_Number>
      XML
      expected_keys = <<-XML
                  <Update_Key type="string">key123</Update_Key>
      XML

      update_keys = ["key123", "key456"]

      expect(orca_api).to receive(:call).
        with(expected_path,
             format: expected_format,
             body: match(/#{Regexp.escape(expected_body)}/).and(match(/#{Regexp.escape(expected_keys)}/)))

      service.delete_nintei_history(update_keys)
    end
  end
end

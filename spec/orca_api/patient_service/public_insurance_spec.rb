require "spec_helper"
require_relative "../shared_examples"

RSpec.describe OrcaApi::PatientService::PublicInsurance, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }

  describe "#get" do
    context "正常系" do
      it "患者公費情報の登録内容を取得できること" do
        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv32_public_01.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "99",
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
              }
            },
            result: "orca12_patientmodv32_99.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.get(1)

        expect(result.ok?).to be true
      end
    end

    context "異常系" do
      it "患者番号に該当する患者が存在しない場合、ロック解除を行わないこと" do
        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "999999",
                }
              }
            },
            result: "orca12_patientmodv32_health_01_E10.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.get(999999)

        expect(result.ok?).to be false
      end
    end
  end

  describe "#update" do
    context "正常系" do
      it "患者公費情報を更新できること" do
        args = {
          "PublicInsurance_Info" => [
            {
              "PublicInsurance_Mode" => "Modify",
              "PublicInsurance_Id" => "4",
              "PublicInsurance_Class" => "968",
              "PublicInsurance_Name" => "後期該当",
              "PublicInsurer_Number" => "",
              "PublicInsuredPerson_Number" => "",
              "Certificate_IssuedDate" => "2017-01-01",
              "Certificate_ExpiredDate" => "2018-01-31",
              "Certificate_CheckDate" => "2018-01-15"
            }
          ]
        }

        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv32_public_01.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
                "PublicInsurance_Information" => args,
              },
            },
            result: "orca12_patientmodv32_public_02.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
                "PublicInsurance_Information" => "`prev['PublicInsurance_Information']`",
              },
            },
            result: "orca12_patientmodv32_public_03.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(1, args)

        expect(result.ok?).to be true
      end

      it "患者公費情報を削除できること" do
        args = {
          "PublicInsurance_Info" => [
            {
              "PublicInsurance_Mode" => "Delete",
              "PublicInsurance_Id" => "4",
              "PublicInsurance_Class" => "968"
            }
          ]
        }

        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv32_public_01.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
                "PublicInsurance_Information" => args,
              },
            },
            result: "orca12_patientmodv32_public_delete_02.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
                "PublicInsurance_Information" => "`prev['PublicInsurance_Information']`",
              },
            },
            result: "orca12_patientmodv32_public_delete_03.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(1, args)

        expect(result.ok?).to be true
      end
    end

    context "異常系" do
      it "患者番号に該当する患者が存在しない場合、ロック解除を行わないこと" do
        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "999999",
                }
              }
            },
            result: "orca12_patientmodv32_health_01_E10.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(999999, {})

        expect(result.ok?).to be false
      end

      it "保険有効開始日＜有効終了日の場合、エラーが発生してロックを解除すること" do
        args = {
          "PublicInsurance_Info" => [
            {
              "PublicInsurance_Mode" => "Modify",
              "PublicInsurance_Id" => "4",
              "PublicInsurance_Class" => "968",
              "PublicInsurance_Name" => "後期該当",
              "PublicInsurer_Number" => "",
              "PublicInsuredPerson_Number" => "",
              "Certificate_IssuedDate" => "2018-01-31",
              "Certificate_ExpiredDate" => "2017-01-01",
              "Certificate_CheckDate" => "2018-01-15"
            }
          ]
        }

        expect_data = [
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "01",
                "Karte_Uid" => orca_api.karte_uid,
                "Patient_Information" => {
                  "Patient_ID" => "1",
                }
              }
            },
            result: "orca12_patientmodv32_public_01.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => '`prev.response_number`',
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
                "PublicInsurance_Information" => args,
              },
            },
            result: "orca12_patientmodv32_public_02_E50.json",
          },
          {
            path: "/orca12/patientmodv32",
            body: {
              "=patientmodv3req2" => {
                "Request_Number" => "99",
                "Karte_Uid" => '`prev.karte_uid`',
                "Orca_Uid" => "`prev.orca_uid`",
                "Patient_Information" => "`prev.patient_information`",
              }
            },
            result: "orca12_patientmodv32_99.json",
          },
        ]

        expect_orca_api_call(expect_data, binding)

        result = service.update(1, args)

        expect(result.ok?).to be false
      end
    end
  end
end

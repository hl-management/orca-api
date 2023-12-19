require "spec_helper"
require_relative "../shared_examples"

RSpec.describe OrcaApi::PatientService::Contraindication, :orca_api_mock do
  let(:service) { described_class.new(orca_api) }
  let(:orca_uid) { SecureRandom.uuid }
  let(:patient_id) { "00064" }

  describe "#get" do
    context "正常系" do
      it "Request_Number=01の戻り値を返す" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01.json"
          when "99"
            load_orca_api_response "orca12_patientmodv37_99.json"
          else
            raise
          end
        end
        result = service.get(patient_id)
        expect(result).to be_ok
      end
    end

    context "異常系" do
      it "他端末使用中であればロック解除APIを呼び出さない" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01_E90.json"
          else
            raise
          end
        end
        result = service.get(patient_id)
        expect(result).to be_locked
      end

      it "Orca_Uidが発行されていればロック解除APIを呼び出す" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01_EXX.json"
          when "99"
            load_orca_api_response "orca12_patientmodv37_99.json"
          else
            raise
          end
        end
        result = service.get(patient_id)
        expect(result).not_to be_ok
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        "Contra_Mode" => "Modify",
        "Patient_Contra_Info" => [
          { "Medication_Code" => "610463147" }
        ]
      }
    end

    context "正常系" do
      it "Request_Number=02の戻り値を返す" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01.json"
          when "02"
            load_orca_api_response "orca12_patientmodv37_02.json"
          else
            raise
          end
        end
        result = service.update(patient_id, params)
        expect(result).to be_ok
      end

      context "Contra_ModeがModifyではない" do
        let(:params) { {} }

        it "Contra_ModeをDeleteにすること" do
          allow(orca_api).to receive(:call) do |_, body:|
            case body["patientmodv3req7"]["Request_Number"]
            when "01"
              load_orca_api_response "orca12_patientmodv37_01.json"
            when "02"
              expect(body["patientmodv3req7"]["Patient_Contra_Information"]).to eq({ "Contra_Mode" => "Delete" })
              load_orca_api_response "orca12_patientmodv37_02.json"
            else
              raise
            end
          end
          result = service.update(patient_id, params)
          expect(result).to be_ok
        end
      end
    end

    context "異常系" do
      it "他端末使用中であればロック解除APIを呼び出さない" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01_E90.json"
          else
            raise
          end
        end
        result = service.update(patient_id, params)
        expect(result).to be_locked
      end

      it "Request_Number=01が失敗したらロック解除APIを呼び出す" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01_EXX.json"
          when "99"
            load_orca_api_response "orca12_patientmodv37_99.json"
          else
            raise
          end
        end
        result = service.update(patient_id, params)
        expect(result).not_to be_ok
      end

      it "Request_Number=02が失敗したらロック解除APIを呼び出す" do
        allow(orca_api).to receive(:call) do |path, body:|
          raise unless path == "/orca12/patientmodv37"

          case body["patientmodv3req7"]["Request_Number"]
          when "01"
            load_orca_api_response "orca12_patientmodv37_01.json"
          when "02"
            load_orca_api_response "orca12_patientmodv37_02_E60.json"
          when "99"
            load_orca_api_response "orca12_patientmodv37_99.json"
          else
            raise
          end
        end
        result = service.update(patient_id, params)
        expect(result).not_to be_ok
      end
    end
  end
end

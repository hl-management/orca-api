require "spec_helper"
require "orca_api/invoice_receipt_service"

RSpec.describe OrcaApi::InvoiceReceiptService do
  orca_model = 'OrcaApi::Api'
  let(:orca_api) { instance_double(orca_model, call: response_body) }
  let(:service) { described_class.new(orca_api) }
  let(:invoice_number) { '123456' }
  let(:patient_id) { '00180' }
  let(:api_path) { '/api01rv2/invoicereceiptv2' }
  let(:req_name) { 'invoice_receiptv2req' }
  let(:response_body) do
    "{\"Information_Date\":\"2025-03-03\",
    \"Information_Time\":\"12:09:27\",
    \"Api_Result\":\"0000\",
    \"Api_Result_Message\":\"処理終了\",
    \"Form_ID\":\"seikyusho\",
    \"Form_Name\":\"請求書兼領収書\",
    \"Print_Date\":\"2025-03-03\",
    \"Print_Time\":\"12:09:27\",
    \"Patient\":{
      \"ID\":\"00180\",
      \"Name\":\"テスト　弐\",
      \"KanaName\":\"テスト　ニ\",
      \"BirthDate\":\"1977-01-04\",
      \"Sex\":\"1\"},
      \"Forms\":[{
        \"data\":{
          \"Form_ID\":\"seikyusho\",
          \"Printer\":\"lp1\",
          \"Order_Class\":\"01\",
          \"Patient\":{
            \"ID\":\"00180\",
            \"Name\":\"テスト　弐\"
          },
          \"Hospital\":{
            \"Name\":[\"医療法人　オルカ医院\"],
            \"ZipCode\":\"1130021\",
            \"Address\":[\"東京都文京区本駒込２−２８−１６\"],
            \"PhoneNumber\":\"03-3946-0001\"},
            \"Period_Class\":\"1\",
            \"Perform_Date\":\"2024-04-15\",
            \"IssuedDate\":\"2024-04-15\",
            \"Department_Name\":\"内科\",
            \"Insurance_Name\":\"協会　　　　\",
            \"Insurance_Rate\":\"  3 割\"
            ,\"Invoice_Number\":\"    123\",
            \"Me\":[
              {
                \"Code\":\"A00\",
                \"Name\":\"初 ・ 再 診 料\",
                \"Point\":\"     125\"
              },
              {
                \"Code\":\"B00\",
                \"Name\":\"医 学 管 理 等\"
              },
              {
                \"Code\":\"C00\",
                \"Name\":\"在　宅　医　療\"
              },
              {
                \"Code\":\"F00\",
                \"Name\":\"投　　　　　薬\"
              },
              {
                \"Code\":\"G00\",
                \"Name\":\"注　　　　　射\"
              },
              {
                \"Code\":\"J00\",
                \"Name\":\"処　　　　　置\"
              },
              {
                \"Code\":\"K00\",
                \"Name\":\"手　　　　　術\"
              },
              {
                \"Code\":\"L00\",
                \"Name\":\"麻　　　　　酔\"
              },
              {
                \"Code\":\"D00\",
                \"Name\":\"検　　　　　査\"
              },
              {
                \"Code\":\"E00\",
                \"Name\":\"画　像　診　断\"
              },
              {
                \"Code\":\"H00\",
                \"Name\":\"リハビリテーション\"
              },
              {
                \"Code\":\"I00\",
                \"Name\":\"精神科専門療法\"
              },
              {
                \"Code\":\"M00\",
                \"Name\":\"放 射 線 治 療\"
              },
              {
                \"Code\":\"N00\",
                \"Name\":\"病　理　診　断\"
              },
              {
                \"Code\":\"A10\",
                \"Name\":\"入　院　料　等\"
              }],
              \"Total_Point\":\"     125\",
              \"Ai_Money\":\"     380\",
              \"Oe_Etc\":[{
                \"Name\":\"予防接種\"
              },
              {
                \"Name\":\"診断書\"
              }],
              \"Ac_Money\":\"     380\",
              \"Tax_In_Ac_Money\":\"       0\",
              \"Last_Ac_Money\":\"       0\",
              \"Total_Ac_Money\":\"     380\",
              \"Ic_Money\":\"       0\",
              \"Caution\":\"※厚生労働省が定める診療報酬や薬価等には、医療機関等が仕入れ時に負担する消費税が反映されています。\"}}]}\n"
  end

  it "parses JSON correctly" do
    patient_id = '00180'
    invoice_number = '123'
    result = service.get(invoice_number, patient_id)
    expect(result["Api_Result_Message"]).to include("処理終了")
    expect(result["Patient"]["ID"]).to include(patient_id)
    expect(result["Forms"].first["data"]["Invoice_Number"]).to include(invoice_number)
  end
end

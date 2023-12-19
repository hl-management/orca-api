require "spec_helper"

RSpec.shared_context "orca_api_mock", :orca_api_mock do
  let(:orca_api) { double("OrcaApi::Client", karte_uid: "karte_uid") }
end

# frozen_string_literal: true

require_relative "service"

module OrcaApi
  # Wraps the CSV data output (statistics data) API.
  # @see https://apic.orcamo.co.jp/api-council/members/standards/?haori_statistics_form#api2
  class StatisticsDataService < Service
    MODES = {
      daily: "Daily",
      monthly: "Monthly"
    }.freeze
    private_constant :MODES

    # @param mode [Symbol]
    #   mode
    #   - :daily
    #   - :monthly
    # @return [OrcaApi::Result]
    def list(mode:)
      raise ArgumentError unless MODES.key? mode

      Result.new(
        orca_api.call(
          "/orca07/statisticsdatav3",
          body: {
            statistics_datav3req: {
              "Request_Number" => "00",
              "Karte_Uid" => orca_api.karte_uid,
              "Statistics_Mode" => MODES[mode]
            }
          }
        )
      )
    end

    # @param data_info [Hash]
    #   an element of the output-data list returned by #list
    #   (a Hash with Statistics_Group_No/Statistics_Processing_Number/Statistics_Serial_Number/
    #    Statistics_Character_Code/Statistics_File_Name)
    # @param mode [Symbol]
    #   mode
    #   - :daily
    #   - :monthly
    # @return [OrcaApi::Result]
    def get(data_info, mode:)
      raise ArgumentError unless MODES.key? mode

      Result.new(
        orca_api.call(
          "/orca07/statisticsdatav3",
          body: {
            statistics_datav3req: {
              "Request_Number" => "01",
              "Karte_Uid" => orca_api.karte_uid,
              "Statistics_Mode" => MODES[mode],
              "Statistics_Data_Information" => {
                "Statistics_Group_No" => data_info["Statistics_Group_No"],
                "Statistics_Processing_Number" => data_info["Statistics_Processing_Number"],
                "Statistics_Serial_Number" => data_info["Statistics_Serial_Number"],
                "Statistics_Character_Code" => data_info["Statistics_Character_Code"],
                "Statistics_File_Name" => data_info["Statistics_File_Name"]
              }
            }
          }
        )
      )
    end
  end
end

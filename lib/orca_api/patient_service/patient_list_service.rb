# frozen_string_literal: true

require_relative "../service"

module OrcaApi
  class PatientService < Service
    # https://www.orca.med.or.jp/receipt/tec/api/patientidlist.html
    class PatientListService < Service
      def list(start_date, end_date, klass)
        req = {
          "Base_StartDate" => start_date,
          "Base_EndDate" => end_date,
        }
        orca_api.call("/api01rv2/patientlst1v2?class=#{klass}", body: { "patientlst1req" => req })
      end
    end
  end
end

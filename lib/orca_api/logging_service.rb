require 'logger'
require 'json'

module OrcaApi
  # Logger Service
  class LoggingService
    attr_reader :logger

    def initialize(logfile_path)
      @logger = Logger.new(logfile_path)
    end

    def log(name, request, response, severity = 'UNKNOWN')
      log_string = generate_log_string(name, request, response, severity)
      write_log(log_string, severity)
    end

    private

    def generate_log_string(name, request, response, severity)
      payload = "{\"request\":{\"url\":\"#{request[:url]}\",\"method\":\"#{request[:method]}\",\"body\":\"#{request[:body]}\"},"
      payload += "\"response\":{\"status\":#{response[:status]},\"body\":\"#{response[:body]}\"}}"
      log_entry = {
        timestamp: Time.now.utc.iso8601,
        logName: name,
        resource: {
          type: "global"
        },
        severity: severity,
        jsonPayload: payload
      }

      <<~LOG
        \n#{JSON.pretty_generate(log_entry)}
      LOG
    end

    def write_log(log_string, severity)
      case severity
      when "INFO"
        logger.info(log_string)
      when "WARNING"
        logger.warn(log_string)
      when "ERROR"
        logger.error(log_string)
      else
        logger.unknown(log_string)
      end
    end
  end
end

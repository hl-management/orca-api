require "net/http"

module OrcaApi
  # エラーを表現するクラス
  class Error < RuntimeError
  end

  # HTTP通信時に発生したエラーを表現するクラス
  class HttpError < Error
    # @!attribute [r] response
    #   エラーが発生したHTTP通信のNet::HTTPResponseオブジェクト
    # @!attribute [r] body
    #   Response body, cached inside Net::HTTP block.
    attr_reader :response, :body

    def initialize(response)
      @response = response
      # Read body inside the block to cache it; accessing after block exit raises IOError.
      @body = response.body.to_s
      super("#{response.message} (#{response.code})")
    rescue IOError
      @body = ""
      super("#{response.message} (#{response.code})")
    end
  end

  # Raised for 503 responses with the WebORCA/WebQKAN session-init marker
  class SessionInitializingError < HttpError
  end
end

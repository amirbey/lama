require 'faraday_middleware'

module LAMA
  module Connection
    private

    def connection(options={})
      merged_options = faraday_options.merge({
        :headers => {
          # 'Accept' => "application/#{response}",
          'User-Agent' => user_agent
        },
        :ssl => {:verify => false},
        :url => endpoint
      })

      ## in Faraday 0.8 or above:
      connection = Faraday.new(merged_options) do |conn|
        conn.request :oauth2, 'TOKEN'
        conn.request :json

        conn.response :xml,  :content_type => /\bxml$/
        conn.response :json, :content_type => /\bjson$/

        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end

## with Faraday 0.7:
      # Faraday.new(merged_options) do |builder|
      #   builder.use Faraday::Connection::basic_auth login, pass
      #   builder.use Faraday::Request::UrlEncoded
      #   builder.use Faraday::Response::RaiseError
      #   builder.use FaradayMiddleware::Mashify
      #   builder.use FaradayMiddleware::ParseXml
      #   builder.adapter(Faraday.default_adapter)
      # end
    end
  end
end


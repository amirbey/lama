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

      Faraday.new(merged_options) do |builder|
        builder.use Faraday::Connection::basic_auth login, pass
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseError
        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseXml
        builder.adapter(Faraday.default_adapter)
      end
    end
  end
end


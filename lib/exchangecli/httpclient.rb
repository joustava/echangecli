require 'net/http'
require 'json'

module ExchangeCLI
  class HTTPClient

    def get(resource, params={})

      uri = URI(resource)
      uri.query = URI.encode_www_form(params)
      get = Net::HTTP::Get.new(uri)

      res = request(get)
      JSON.parse(res.body, {symbolize_names: true}) if res.is_a?(Net::HTTPSuccess)
    end

    def post(resource, body={}, headers={})
      uri = URI(resource)
      post = Net::HTTP::Post.new(uri, 'Content-Type': 'application/json')
      post.body = body.to_json

      request(post, true)
    end

    private
    # req = Net::HTTP::Post.new(@webhook_url, 'Content-Type': 'application/json')
    # req.body = body.to_json
    # res = Net::HTTP.start(@webhook_url.hostname, use_ssl: true) do |http|
    #   http.request(req)
    # end
    def request(request, ssl=false)
      Net::HTTP.start(request.uri.hostname, use_ssl: ssl) do |http|
        http.request(request)
      end
    end
  end
end

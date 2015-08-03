require 'net/http'
require 'json'

module Waterloo
  class ApiClient
    BASE_URL = 'https://api.uwaterloo.ca/v2'

    def initialize(key, term = nil)
      @key = key
      @term = term
    end

    def get_course(id)
      uri = URI.parse(BASE_URL + "/courses/#{id}/schedule.json?key=#{@key}&term=#{@term}")
      get_http(uri)['data'][0]
    end

    def get_term(id)
      uri = URI.parse(BASE_URL + "/terms/list.json?key=#{@key}&term=#{@term}")
      term = get_http(uri)['data']['listings'].values.flatten.find { |t| t['id'] == id }
      term ? term : { name: 'Unknown Term' }
    end

    private

      def get_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        JSON.parse(http.get(uri.request_uri).body)
      end
  end
end

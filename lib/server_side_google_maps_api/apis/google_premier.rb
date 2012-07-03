require 'openssl'
require 'base64'
require 'server_side_google_maps_api/apis/google'

module ServerSideGoogleMapsApi::Api
  class GooglePremier < Google

    private # ---------------------------------------------------------------

    def query_url(service, query)
      params = {
          :sensor => 'false',
          :language => ServerSideGoogleMapsApi::Configuration.language,
          :client => ServerSideGoogleMapsApi::Configuration.api_key[1],
          :channel => ServerSideGoogleMapsApi::Configuration.api_key[2]
      }.merge!(query).reject { |key, value| value.nil? }

      path = "/maps/api/geocode/json?#{hash_to_query(params)}"
      puts "#{protocol}://maps.googleapis.com#{path}&signature=#{sign(path)}"
      "#{protocol}://maps.googleapis.com#{path}&signature=#{sign(path)}"
    end

    def sign(string)
      raw_private_key = url_safe_base64_decode(ServerSideGoogleMapsApi::Configuration.api_key[0])
      digest = OpenSSL::Digest::Digest.new('sha1')
      raw_signature = OpenSSL::HMAC.digest(digest, raw_private_key, string)
      url_safe_base64_encode(raw_signature)
    end

    def url_safe_base64_decode(base64_string)
      Base64.decode64(base64_string.tr('-_', '+/'))
    end

    def url_safe_base64_encode(raw)
      Base64.encode64(raw).tr('+/', '-_').strip
    end
  end
end

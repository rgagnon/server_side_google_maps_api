require 'server_side_google_maps_api/apis/base'
require "server_side_google_maps_api/apis/google"
require 'server_side_google_maps_api/configuration'
require 'geocoder/exceptions'

module ServerSideGoogleMapsApi::Api
  class Google < Base

    private # ---------------------------------------------------------------

    def results(service, query)
      return [] unless doc = fetch_data(service, query)
      case doc['status']; when "OK" # OK status implies >0 results
        return doc
      when "OVER_QUERY_LIMIT"
        raise_error(Geocoder::OverQueryLimitError) ||
          warn("Google Geocoding API error: over query limit.")
      when "REQUEST_DENIED"
        warn "Google Geocoding API error: request denied."
      when "INVALID_REQUEST"
        warn "Google Geocoding API error: invalid request."
      end
      return []
    end

    def query_url(service, query)
      params = {
        :sensor => "false",
        :language => ServerSideGoogleMapsApi::Configuration.language,
        :key => ServerSideGoogleMapsApi::Configuration.api_key
      }.merge!(query)
      "#{protocol}://maps.googleapis.com/maps/api/#{service}/json?" + hash_to_query(params)
    end
  end
end


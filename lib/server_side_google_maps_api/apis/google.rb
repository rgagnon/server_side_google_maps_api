require 'server_side_google_maps_api/apis/base'
require "server_side_google_maps_api/apis/google"
require 'server_side_google_maps_api/configuration'

module ServerSideGoogleMapsApi::Api
  class Google < Base

    private # ---------------------------------------------------------------

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query, reverse)
      case doc['status']; when "OK" # OK status implies >0 results
        return doc['results']
      when "OVER_QUERY_LIMIT"
        raise_error(ServerSideGoogleMapsApi::OverQueryLimitError) ||
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


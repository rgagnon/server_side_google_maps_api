require 'net/http'
require 'uri'

unless defined?(ActiveSupport::JSON)
  begin
    require 'rubygems' # for Ruby 1.8
    require 'json'
  rescue LoadError
    raise LoadError, "Please install the 'json' or 'json_pure' gem to parse google maps api results."
  end
end

module ServerSideGoogleMapsApi
  module Api
    class Base

      ##
      # Query the geocoding API and return a ::Result object.
      # Returns +nil+ on timeout or error.
      #
      def search(service, query)

        # if coordinates given as string, turn into array
        query = query.split(/\s*,\s*/) if coordinates?(query)

        if query.is_a?(Array)
          query = query.join(',')
        end

        results(service, query)
      end

      private # -------------------------------------------------------------

      ##
      # Object used to make HTTP requests.
      #
      def http_client
        Net::HTTP
      end

      ##
      # ServerSideGoogleMapsApi::Result object or nil on timeout or other error.
      #
      def results(query)
        fail
      end

      ##
      # URL to use for querying the geocoding engine.
      #
      def query_url(query)
        fail
      end

      ##
      # Returns a parsed search result (Ruby hash).
      #
      def fetch_data(service, query)
        begin
          parse_raw_data fetch_raw_data(service, query)
        rescue SocketError => err
          raise_error(err) or warn "Google maps API connection cannot be established."
        rescue TimeoutError => err
          raise_error(err) or warn "Google maps API not responding fast enough " +
                                       "(see ServerSideGoogleMapsApi::Configuration.timeout to set limit)."
        end
      end

      ##
      # Raise exception if configuration specifies it should be raised.
      # Return false if exception not raised.
      #
      def raise_error(error, message = nil)
        if ServerSideGoogleMapsApi::Configuration.always_raise.include?(error.is_a?(Class) ? error : error.class)
          raise error, message
        else
          false
        end
      end

      ##
      # Parses a raw search result (returns hash or array).
      #
      def parse_raw_data(raw_data)
        begin
          if defined?(ActiveSupport::JSON)
            ActiveSupport::JSON.decode(raw_data)
          else
            JSON.parse(raw_data)
          end
        rescue
          warn "Google maps API's response was not valid JSON."
        end
      end

      ##
      # Protocol to use for communication with geocoding services.
      # Set in configuration but not available for every service.
      #
      def protocol
        "http" + (ServerSideGoogleMapsApi::Configuration.use_https ? "s" : "")
      end

      ##
      # Fetches a raw search result (JSON string).
      #
      def fetch_raw_data(service, query)
        timeout(ServerSideGoogleMapsApi::Configuration.timeout) do
          url = query_url(service, query)
          uri = URI.parse(url)

          puts "uri:#{uri}"
          client = http_client.new(uri.host, uri.port)
          client.use_ssl = true if ServerSideGoogleMapsApi::Configuration.use_https
          response = client.get(uri.request_uri)
          puts "response.body:#{response.body}"
          body = response.body
        end
      end

      ##
      # Is the given string a loopback IP address?
      #
      def loopback_address?(ip)
        !!(ip == "0.0.0.0" or ip.to_s.match(/^127/))
      end

      ##
      # Does the given string look like latitude/longitude coordinates?
      #
      def coordinates?(value)
        value.is_a?(String) and !!value.to_s.match(/^-?[0-9\.]+, *-?[0-9\.]+$/)
      end

      ##
      # Simulate ActiveSupport's Object#to_query.
      # Removes any keys with nil value.
      #
      def hash_to_query(hash)
        require 'cgi' unless defined?(CGI) && defined?(CGI.escape)
        hash.collect { |p|
          p[1].nil? ? nil : p.map { |i| CGI.escape args_value_to_query(i) } * '='
        }.compact.sort * '&'
      end

      def args_value_to_query(value)
        if value.respond_to?(:join)
          value = value.join('|')
        else
          value = value.to_s
        end
      end
    end
  end
end

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

      private # -------------------------------------------------------------

      ##
      # ServerSideGoogleMapsApi::Result object or nil on timeout or other error.
      #
      def results(query, reverse = false)
        fail
      end

      ##
      # URL to use for querying the geocoding engine.
      #
      def query_url(query, reverse = false)
        fail
      end

      ##
      # Returns a parsed search result (Ruby hash).
      #
      def fetch_data(query, reverse = false)
        begin
          parse_raw_data fetch_raw_data(query, reverse)
        rescue SocketError => err
          raise_error(err) or warn "Google maps API connection cannot be established."
        rescue TimeoutError => err
          raise_error(err) or warn "Google maps API not responding fast enough " +
            "(see ServerSideGoogleMapsApi::Configuration.timeout to set limit)."
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
      def fetch_raw_data(query, reverse = false)
        timeout(ServerSideGoogleMapsApi::Configuration.timeout) do
          url = query_url(query, reverse)
          uri = URI.parse(url)
          unless cache and body = cache[url]
            client = http_client.new(uri.host, uri.port)
            client.use_ssl = true if ServerSideGoogleMapsApi::Configuration.use_https
            response = client.get(uri.request_uri)
            body = response.body
            if cache and (200..399).include?(response.code.to_i)
              cache[url] = body
            end
          end
          body
        end
      end

      ##
      # The working Cache object.
      #
      def cache
        ServerSideGoogleMapsApi.cache
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
        hash.collect{ |p|
          p[1].nil? ? nil : p.map{ |i| args_value_to_query(i)} * '='
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

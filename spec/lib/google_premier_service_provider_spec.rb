require "#{File.dirname(__FILE__)}/../spec_helper"

require 'server_side_google_maps_api/apis/google_premier'

describe ServerSideGoogleMapsApi::Api::GooglePremier do
  before { ServerSideGoogleMapsApi::Configuration.api_key = ['test', 'gme-test', 'google_maps_test'] }
  let(:google) { ServerSideGoogleMapsApi::Api::GooglePremier.new }

  it "should be a google object" do
    google.should be_a ServerSideGoogleMapsApi::Api::GooglePremier
  end

  it "should build the query url for google webservice" do
    google.send(:query_url, :distancematrix, {:origins => [1, 1], :destinations => [2, 2], :mode => :driving}).should == 'http://maps.googleapis.com/maps/api/geocode/json?channel=google_maps_test&client=gme-test&destinations=2|2&language=en&mode=driving&origins=1|1&sensor=false&signature=z5Av2ADeLYzY62kloUfKWK9m0uc='
  end

end

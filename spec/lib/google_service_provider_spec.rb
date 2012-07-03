require "#{File.dirname(__FILE__)}/../spec_helper"

require 'server_side_google_maps_api/apis/google'

describe ServerSideGoogleMapsApi::Api::Google do
  let(:google) { ServerSideGoogleMapsApi::Api::Google.new }

  it "should be a google object" do
    google.should be_a ServerSideGoogleMapsApi::Api::Google
  end

  it "should build the query url for google webservice" do
    google.send(:query_url, :distancematrix, {:origins => [1, 1], :destinations => [2, 2], :mode => :driving}).should == 'http://maps.googleapis.com/maps/api/distancematrix/json?destinations=2|2&key=test|gme-test|google_maps_test&language=en&mode=driving&origins=1|1&sensor=false'
  end

end

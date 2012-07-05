require "#{File.dirname(__FILE__)}/../spec_helper"

require 'server_side_google_maps_api/apis/google_premier'

describe ServerSideGoogleMapsApi::Api::GooglePremier do
  before { ServerSideGoogleMapsApi::Configuration.api_key = ['test', 'gme-test', 'google_maps_test'] }
  let(:google) { ServerSideGoogleMapsApi::Api::GooglePremier.new }

  it "should be a google object" do
    google.should be_a ServerSideGoogleMapsApi::Api::GooglePremier
  end

  it "should build the query url for google webservice" do
    google.send(:query_url, :distancematrix, {:origins => [1, 1], :destinations => [2, 2], :mode => :driving}).should == 'http://maps.googleapis.com/maps/api/distancematrix/json?channel=google_maps_test&client=gme-test&destinations=2%7C2&language=en&mode=driving&origins=1%7C1&sensor=false&signature=iRyDDBqmcPiqAlbUMFnlehFxBnY='
  end
  
  it "should query google api and return a json" do
    google.search(:distancematrix, {:origins => [1, 1], :destinations => [2, 2], :mode => :driving}).should be_a Hash
  end
  

end

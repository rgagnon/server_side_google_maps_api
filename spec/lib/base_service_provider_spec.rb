require "#{File.dirname(__FILE__)}/../spec_helper"

require 'server_side_google_maps_api/apis/base'

describe ServerSideGoogleMapsApi::Api::Base do
  let(:base) { ServerSideGoogleMapsApi::Api::Base.new }

  it "should be a base object" do
    base.should be_a ServerSideGoogleMapsApi::Api::Base
  end

  describe "Building query string from params" do
    it "should build the simple query from string arg" do
      base.send(:hash_to_query, {:test => 'test'}).should == "test=test"
    end

    it "should build the simple query from array arg" do
      base.send(:hash_to_query, {:test => ['test', 'test1']}).should == "test=test%7Ctest1"
    end

    it "should build the simple query with multiple args" do
      base.send(:hash_to_query, {:test2 =>['test', 'test3'] ,  :test => ['test', 'test1']}).should == "test2=test%7Ctest3&test=test%7Ctest1"
    end

    it "should build args value query from string" do
      base.send(:args_value_to_query, 'test').should == "test"
    end

    it "should build args value query from array" do
      base.send(:args_value_to_query, ['test','test1']).should == "test|test1"
    end
  end

end

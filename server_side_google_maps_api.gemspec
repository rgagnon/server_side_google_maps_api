$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "server_side_google_maps_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "server_side_google_maps_api"
  s.version     = ServerSideGoogleMapsApi::VERSION
  s.authors     = ["Rémi Gagnon"]
  s.email       = ["rem.gagnon@gmail.com"]
  s.homepage    = "https://github.com/rgagnon/server_side_google_maps_api.git"
  s.summary     = "a little gem to query the server side google maps api. Inspired from GeoCoder gem"
  s.description = "a little gem to query the server side google maps api. Inspired from GeoCoder gem"

  s.files = Dir["{app,config,db,lib}/**/*", 'lib/*' ] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.3"
  # s.add_dependency "jquery-rails"

  #s.add_development_dependency "ruby-oci8"
end

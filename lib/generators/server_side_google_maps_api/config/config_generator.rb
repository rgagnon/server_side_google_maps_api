require 'rails/generators'

module ServerSideGoogleMapsApi
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "This generator creates an initializer file at config/initializers, " +
         "with the default configuration options for ServerSideGoogleMapsApi."
    def add_initializer
      template "initializer.rb", "config/initializers/server_side_google_maps_api.rb"
    end
  end
end


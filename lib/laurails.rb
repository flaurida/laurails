require 'laurails/asset_server'
require 'laris/controller'
require 'laris/exception_viewer'
require 'laurails/laurailsrecord'
require 'laurails/router'

module Laurails
  def self.app
    DBConnection.reset

    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      Laurails::Router.run(req, res)
      res.finish
    end

    Rack::Builder.new do
      use ExceptionViewer
      use AssetServer
      run app
    end
  end

  def self.root=(root)
    const_set(:ROOT, root)
  end
end

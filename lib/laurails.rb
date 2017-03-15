require_relative 'asset_server'
require_relative 'controller'
require_relative 'exception_viewer'
require_relative 'laurails/laurailsrecord'
require_relative 'router'
require 'rack'

module Laurails
  Laurails::Router = Router.new

  def self.app
    DBConnection.instance

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

  def self.run
    Rack::Server.start(
      app: self.app,
      Port: 3000
    )
  end

  def self.root=(root)
    const_set(:ROOT, root)
  end
end

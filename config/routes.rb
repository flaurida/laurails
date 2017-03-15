require_relative '../app/controllers/hedgehogs_controller'
require_relative '../app/controllers/houses_controller'

Laurails::Router.draw do
  get Regexp.new("^/$"), HedgehogsController, :index
  get Regexp.new("^/hedgehogs$"), HedgehogsController, :index
  get Regexp.new("^/hedgehogs/new$"), HedgehogsController, :new
  post Regexp.new("^/hedgehogs$"), HedgehogsController, :create
  delete Regexp.new("^/hedgehogs/(?<hedgehog_id>\\d+)$"), HedgehogsController, :destroy
  get Regexp.new("^/hedgehogs/(?<hedgehog_id>\\d+)$"), HedgehogsController, :show
  get Regexp.new("^/houses$"), HousesController, :index
end

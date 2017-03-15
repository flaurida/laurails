require_relative '../models/hedgehog'
require_relative '../models/person'
require_relative '../models/house'

class HousesController < ControllerBase
  def index
    @houses = House.all
    render :index
  end
end

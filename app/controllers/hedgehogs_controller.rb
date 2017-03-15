require_relative '../models/hedgehog'
require_relative '../models/person'

class HedgehogsController < ControllerBase
  def index
    @hedgehogs = Hedgehog.all
    render :index
  end

  def new
    @hedgehog = Hedgehog.new
    render :new
  end

  def create
    @hedgehog = Hedgehog.new(
      name: params['hedgehog']['name'],
      color: params['hedgehog']['color'],
      owner_id: params['hedgehog']['owner_id']
    )

    if @hedgehog.save
      redirect_to "/"
    else
      flash.now[:errors] = @hedgehog.errors
      render :new
    end
  end

  def destroy
    @hedgehog = Hedgehog.find(params['hedgehog_id'])
    @hedgehog.destroy

    redirect_to "/"
  end

  def show
    @hedgehog = Hedgehog.find(params['hedgehog_id'])
    render :show
  end
end

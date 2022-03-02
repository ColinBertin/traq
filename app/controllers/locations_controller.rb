class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @locations = policy_scope(Location).order(created_at: :desc)
  end

  def show
    @location = Location.find(params[:id])
    authorize @location
    @contributions = Contribution.where(:location == @location)
  end

  def new
    @location = Location.new
    authorize @location
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_user
    authorize @location
    if @location.save
      redirect_to locations_path
    else
      render :new
    end
  end

  def edit
    @location = Location.find(params[:id])
    authorize @location
  end

  def update
    @location = Location.find(params[:id])
    authorize @location
    @location.update(location_params)
    redirect_to location_path(@location)
  end

  def destroy
    @location = Location.find(params[:id])
    authorize @location
    @location.destroy
    redirect_to locations_path
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :location_type)
  end
end

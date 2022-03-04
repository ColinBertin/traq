class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @locations = policy_scope(Location).order(created_at: :desc)
    if params[:search].present?
      @locations = Location.global_search(params[:search]["search"])
    end
    @markers = @locations.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude
      }
    end
  end

  def show
    @location = Location.find(params[:id])
    authorize @location
    @location_contributions = Contribution.where(location_id: @location.id) # current location show...?
    @comment = Comment.new
    @comments = Comment.where(location_id: @location.id)
    @marker_location = Location.where(id: params[:id])
    @markers = @marker_location.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude
      }
    end
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

class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @locations = policy_scope(Location).includes(:contributions).order(created_at: :desc)
    params[:search].present? && @locations = Location.global_search(params[:search]["search"])
    @markers = @locations.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude,
        id: location.id,
        info_window: render_to_string(partial: "info_window", locals: { location: location }),
        image_url: helpers.asset_url(marker_icon(location.location_type))
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
        lng: location.longitude,
        id: location.id,
        image_url: helpers.asset_url(marker_icon(location.location_type))
      }
    end
    @checkin = Checkin.new
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

  def marker_icon(location)
    case location
    when "contributor"
      return 'contribution_location.png'
    when "ngo"
      return 'ngo.png'
    when "shelter"
      return 'shelter.png'
    else
      return 'location-sign.png'
    end
  end
end

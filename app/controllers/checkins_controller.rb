class CheckinsController < ApplicationController
  def create
    @checkin = Checkin.new
    location = Location.find(params[:location_id])
    @checkin.location = location
    @checkin.user = current_user
    @checkin.save
    authorize @checkin
    redirect_to location_path(location), notice: "Thank you for checking in!"
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    location = Location.find(params[:location_id])
    authorize @checkin
    @checkin.destroy
    redirect_to location_path(location)
  end
end

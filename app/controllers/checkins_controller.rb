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
end

class CheckinsController < ApplicationController
  def create
    @checkin = Checkin.new
    location = Location.find(params[:location_id])
    @checkin.location = location
    @checkin.user = current_user
    authorize @checkin
    respond_to do |format|
      if @checkin.save
        format.html { redirect_to location_path(location), notice: "Thank you for checking in!" }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end
end

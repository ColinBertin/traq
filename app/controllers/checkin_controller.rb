class CheckinController < ApplicationController
  def new
    @location = Loction.find(params[:location_id])
    @user = User.new(current_user)
    @checkin = Checkin.new(:location_id)
  end

  def create
  end
end

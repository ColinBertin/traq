class ContributionsController < ApplicationController
  def index
    @contributions = policy_scope(Contribution).order(created_at: :desc)
  end

  def new
    @contribution = Contribution.new
    @location = Location.find(params[:location_id])
    authorize @contribution
  end

  def create
    @contribution = Contribution.new(contribution_params)
    @location = Location.find(params[:location_id])
    @contribution.location = @location
    @contribution.user = current_user
    authorize @contribution
    if @contribution.save
      redirect_to location_path(@location)
    else
      render :new
    end
  end

  def edit
  end

  private

  def contribution_params
    params.require(:contribution).permit(:supply_type, :description, :quantity)
  end
end
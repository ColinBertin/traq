class ContributionsController < ApplicationController
  def index
    @contributions = policy_scope(Contribution).order(created_at: :desc)
  end

  def new
    @contribution = Contribution.new
    authorize @contribution
  end

  def create
    @location = Location.find(params[:id])
    @contribution = Contribution.new(contribution_params)
    @contribution.location = @location
    @contributor.user = current_user
    authorize @contribution
    if @contribution.save
      redirect_to users_contributions
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

class ContributionsController < ApplicationController
  def index
    @contributions = policy_scope(Contribution).order(created_at: :desc)
    if params[:query].present?
      @contributions = @contributions.where("supply_type ILIKE ?", "%#{params[:query]}%")
      @contributions.tag_list.add("food, water, supplies, first aid, clothing, shelter", parse: true)
    end
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
    @contribution = Contribution.find(params[:id])
    authorize @contribution
  end

  def update
    @contribution = Contribution.find(params[:id])
    authorize @contribution
    @contribution.update(contribution_params)
    redirect_to users_contributions_path
  end

  private

  def contribution_params
    params.require(:contribution).permit(:supply_type, :description, :quantity, :tag_list)
  end
end

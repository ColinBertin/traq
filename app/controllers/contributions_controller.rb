class ContributionsController < ApplicationController
  act_as_taggable_on :tags
  act_as_taggable_on :supply_type
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

  def tagged
    if params[:tag].present?
      @contributions =  Contribution.tagged_with(params[:id])
    else
      @contributions = Contributions.all
  end

  def edit
  end

  private

  def contribution_params
    params.require(:contribution).permit(:supply_type, :description, :quantity, :tag_list)
  end
end

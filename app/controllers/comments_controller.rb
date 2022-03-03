class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @comments = policy_scope(Comment).order(created_at: :desc)
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.location = Location.find(params[:location_id])
    authorize @comment
    if @comment.save
      redirect_to location_path(@comment.location, anchor: "comment-#{@comment.id}")
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

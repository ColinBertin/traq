class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @comments = policy_scope(Comment).order(created_at: :desc)
  end

  def new
    @comment = Comment.new
    authorize @comment
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      redirect_to location_comments_path
    else
      render :new
    end
  end

  private

  def commment_params
    params.require(:content).permit(:user, :location)
  end
end

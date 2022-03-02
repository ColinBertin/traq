class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.location = Location.find(params[:id])
    authorize @comment
    if @comment.save
      redirect_to location_path(@comment.location)
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

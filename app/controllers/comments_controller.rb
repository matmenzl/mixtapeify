class CommentsController < ApplicationController
  def create
    status = Status.find params[:status_id]
    comment = status.comments.new comment_params
    comment.user_id = current_user.id
    if comment.save
      flash[:notice] = "Your comment has been saved!"
    else
      flash[:notice] = "There was a problem saving your comment. Please try again later or contact the support team."
    end
    redirect_to status
  end

  private
  def comment_params
    params.require(:comment).permit(:title, :comment)
  end
end
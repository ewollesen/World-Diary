class CommentsController < ApplicationController
  load_resource :subject, find_by: :permalink
  before_filter :new_comment, only: [:new, :create]
  authorize_resource


  def create
    @comment.user = current_user

    if @comment.save
      redirect_to @subject, {notice: "Comment created successfully."}
    else
      redirect_to @subject, {error: "Error creating comment."}
    end
  end


  protected

  def new_comment
    @comment = @subject.comments.new(comment_params) do |c|
      c.user = current_user
    end
  end

  def comment_params
    params.require(:comment).permit(:comment, :subject_id)
  end

end

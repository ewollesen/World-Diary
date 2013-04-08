class CommentsController < ApplicationController
  load_resource :subject, :find_by => :permalink
  load_resource :comment, through: :subject
  authorize_resource

  def create
    @comment.user = current_user

    if @comment.save
      redirect_to @subject, {notice: "Comment created successfully."}
    else
      redirect_to @subject, {error: "Error creating comment."}
    end
  end

end

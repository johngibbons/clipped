class CommentsController < ApplicationController

  def create
    @upload = Upload.find(params[:comment][:commentee_id])
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @upload }
        format.js
      else
        flash.now[:error] = "There was an issue with your comment.  Please try again"
        format.html { redirect_to @upload }
      end
    end
  end

  def destroy
    @upload = Comment.find(params[:id]).commentee
    @comment = current_user.delete_comment(params[:id])
    authorize @comment
    respond_to do |format|
      format.html { redirect_to @upload }
      format.js
    end
  end

  def comment_params
    params.require(:comment).permit(:comment_body, :commentee_id)
  end
end

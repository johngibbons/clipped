class CommentsController < ApplicationController

  def create
    @upload = Upload.find(params[:comment][:commentee_id])
    @comment = current_user.comments.new(comment_params)
    authorize @comment
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
    @comment = Comment.find(params[:id])
    authorize @comment
    respond_to do |format|
      if( @comment.destroy! )
        format.html { redirect_to @upload }
        format.js
      else
        flash.now[:error] = "Comment not deleted.  Please try again"
        format.html { redirect_to @upload }
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :commentee_id)
  end
end

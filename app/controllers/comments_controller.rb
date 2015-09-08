class CommentsController < ApplicationController

  def new
    if params[:parent_id]
      @parent = Comment.find(params[:parent_id])
    end
    @comment = Comment.new(parent_id: params[:parent_id])
    @upload = Upload.find(params[:id])
  end

  def create
    if params[:comment][:parent_id].to_i > 0
      @parent = Comment.find(params[:comment].delete(:parent_id))
      @comment = @parent.children.build(comment_params)
      @comment.commenter = current_user
    else
      @comment = current_user.comments.new(comment_params)
    end
    @upload = Upload.find(params[:comment][:commentee_id])
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

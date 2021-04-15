module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_commentable, only: [:create_comment]
    after_action :publish_comment, only: [:create_comment]
  end

  def create_comment
    if current_user
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user
      @comment.save
      render partial: 'comments/create_comment'
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      'comments', 
      comment: @comment, 
      user_email: @comment.user.email
    )
  end
end

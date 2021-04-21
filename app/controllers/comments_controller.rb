class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]
  after_action :publish_comment, only: [:create]
  

  def create
    if current_user
      Rails.logger.info params
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user
      @comment.save
    end
  end

  private

  def set_commentable
    if params[:answer_id].nil?
      @commentable = Question.find(params[:question_id])
    else
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment&.errors&.any?
    ActionCable.server.broadcast(
      "comments#{commentable_id}", 
      comment: @comment, 
      email: @comment&.user&.email
    )
  end

  def commentable_id
    if @commentable.is_a?(Question)
      @commentable.id
    else
      @commentable.question_id
    end
  end
end

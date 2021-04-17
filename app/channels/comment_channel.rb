class CommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments#{params[:question_id]}"
    Rails.logger.info params
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class SubscriptionsController < ApplicationController

  before_action :load_question, only: [:create, :destroy]

  authorize_resource

  def create
    current_user&.subscriptions&.find_or_create_by(question: @question)
    render json: { question_id: @question.id }
  end

  def destroy
    @subscription = current_user&.subscriptions&.find_by(question: @question)
    @subscription.destroy
    render json: { question_id: @question.id }
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end

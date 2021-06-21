class SubscriptionsController < ApplicationController

  before_action :load_question, only: [:create, :destroy]

  authorize_resource

  def create
    @subscribe = current_user&.subscriptions&.find_by(question: @question)
    if @subscribe.nil?
      @question.subscriptions.create!(user: current_user)
    end
    render json: { question_id: @question.id }
  end

  def destroy
    @subscribe = current_user&.subscriptions&.find_by(question: @question)
    @subscribe.destroy
    render json: { question_id: @question.id }
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end

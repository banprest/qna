class AnswersController < ApplicationController
  before_action :load_question, only: [:index]

  def index
    @answers = @question.answers
  end

  private
    
  def load_question
    @question = Question.find(params[:question_id])  
  end
end

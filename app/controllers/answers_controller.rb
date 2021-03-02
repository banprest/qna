class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :new]
  before_action :load_answer, only: [:show]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  private
    
  def load_question
    @question = Question.find(params[:question_id])  
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end

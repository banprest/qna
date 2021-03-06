class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:index, :new, :create]
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :best]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author?(@answer)
      @question = @answer.question
      @answer.destroy
    end
  end

  def best
    @answer.mark_as_best if current_user.author?(@answer)
    @question = @answer.question 
  end

  private
    
  def load_question
    @question = Question.find(params[:question_id])  
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end

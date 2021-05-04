class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:index, :new, :create]
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :best]
  after_action :publish_answer, only: [:create]

  authorize_resource
  
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
    @comment = Comment.new
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
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                  links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "answers#{@question.id}", 
      answer: @answer,
      answer_link: @answer.links
    )
  end
end

class AnswersController < ApplicationController
  include Voted

  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :best]
  after_action :publish_answer, only: [:create]

  authorize_resource

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

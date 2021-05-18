class Api::V1::QuestionsController < Api::V1::BaseController
  
  before_action :find_question, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    @question.valid? ? render_json(@question) : status_and_errors(@question)
  end

  def update
    @question.update(question_params)
    @question.valid? ? render_json(@question) : status_and_errors(@question)
  end

  def destroy
    @question = Question.with_attached_files.find(params[:id])
    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end

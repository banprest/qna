class Api::V1::QuestionsController < Api::V1::BaseController
  
  authorize_resource 

  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    render json: @question if @question.valid?
  end

  def update
    @question.update!(question_params) if current_resource_owner.author?(@question)
    render json: @question
    #не понимаю почему при update он рендерит вопрос при условии что он не валидный хотя в базе прописано nil: false
  end

  def destroy
    @question = Question.with_attached_files.find(params[:id])
    @question.destroy if current_resource_owner.author?(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end

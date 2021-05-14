class Api::V1::AnswersController < Api::V1::BaseController
  
  before_action :find_answer, only: [:show, :update, :destroy]

  def show
    render json: @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
    render json: @answer if @answer.valid?
  end

  def update
    @answer.update!(answer_params) if current_resource_owner.author?(@answer)
    render json: @answer
    #не понимаю почему при update он рендерит вопрос при условии что он не валидный хотя в базе прописано nil: false
  end

  def destroy
    @answer.destroy if current_resource_owner.author?(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end

class Api::V1::AnswersController < Api::V1::BaseController

  before_action :find_answer, only: [:show, :update, :destroy]

  authorize_resource

  def show
    render json: @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
    @answer.valid? ? render_json(@answer) : status_and_errors(@answer)
  end

  def update
    @answer.update(answer_params)
    @answer.valid? ? render_json(@answer) : status_and_errors(@answer)
  end

  def destroy
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end

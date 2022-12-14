class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionSerializer
  end

  def show
    render json: question, serializer: QuestionDataSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, status: :created, serializer: QuestionDataSerializer
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, serializer: QuestionDataSerializer
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
    render json: { messages: ["Question was successfully deleted"] }
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new

    gon.push({current_user: current_user})
    gon.push({question_id: @question.id})
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to question_path(@question), notice: "Your question was successfully created."
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
      @question.destroy
      redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], reward_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      "questions",
      {
        partial: ApplicationController.render(
          partial: "questions/question",
          locals: { question: @question, current_user: current_user }
        )
      }
    )
  end

  def subscription
    @subscription ||= question.subscriptions.find_by(user: current_user)
  end

  helper_method :subscription
end

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
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
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Question successfully deleted."
    else
      redirect_to questions_path, notice: "You have no rights to delete this question."
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end

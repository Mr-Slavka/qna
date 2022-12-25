class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: :destroy

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription.destroy
  end

  private

  def load_subscription
    @subscription = current_user.subscriptions.find_by(question_id: params[:id])
  end
end

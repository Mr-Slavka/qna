module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down unvote]
  end

  def vote_up
    return errors_response if current_user.author?(@votable)
    return errors_response if @votable.vote_of?(current_user)

    @votable.vote_up(current_user)
    success_response
  end

  def vote_down
    return errors_response if current_user.author?(@votable)
    return errors_response if @votable.vote_of?(current_user)

    @votable.vote_down(current_user)
    success_response
  end

  def unvote


    @votable.unvote(current_user)
    success_response
  end

  private

  def errors_response
    render json: { message:["you have already voted"], name: @votable.class.name.underscore, id: @votable.id }, status: :forbidden
  end

  def success_response
    render json: { name: @votable.class.name.underscore, id: @votable.id, rating: @votable.rating }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end

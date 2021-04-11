module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    unless current_user.author?(@votable)
      @votable.vote(current_user, 1)
      render_json_template(@votable)
    end 
  end

  def vote_down
    unless current_user.author?(@votable)
      @votable.vote(current_user, -1)
      render_json_template(@votable)
    end
  end

  def cancel_vote
    unless current_user.author?(@votable)
      @votable.cancel_vote(current_user)
      render_json_template(@votable)
    end
  end

  private

  def render_json_template(object)
   render json: { id: object.id, rating: object.rating, voted: current_user&.voted?(object) } 
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
